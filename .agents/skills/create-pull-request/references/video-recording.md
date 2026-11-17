# Video recording

A reviewer must follow the video without the code: what is on the screen, where each click happens and what each action changes.

## Before you record

- Write the steps first. Each step is one action and one visible result.
- Frame all the relevant part of the screen: the place of the action and its result. If the result shows far from the click (a toast, a side panel, a new tab), keep both in the frame. Do not crop to the clicked element.
- Use the same viewports as the screenshots: 1440 × 900 on desktop and 390 × 844 on mobile.
- Keep each video under 60 s and 10 MB. Split a longer flow into several videos.

## Show the cursor, the clicks and the keys

Headless browsers do not draw the cursor. With Playwright, add this script to the context before you open the page. It draws a cursor that follows the mouse, a ring on each click, and a label with each keyboard shortcut:

```ts
import type { BrowserContext } from "@playwright/test";

export async function showPointerAndKeys(context: BrowserContext): Promise<void> {
	await context.addInitScript(() => {
		const style = document.createElement("style");
		style.textContent = `
			#pr-cursor { position: fixed; z-index: 2147483647; width: 18px; height: 18px; margin: -9px 0 0 -9px; border-radius: 50%; background: rgba(239, 68, 68, .85); border: 2px solid #fff; box-shadow: 0 0 0 1px rgba(0,0,0,.4); pointer-events: none; transition: transform .1s; }
			#pr-cursor.pressed { transform: scale(.7); }
			.pr-click { position: fixed; z-index: 2147483646; width: 44px; height: 44px; margin: -22px 0 0 -22px; border-radius: 50%; border: 3px solid rgba(239, 68, 68, .9); pointer-events: none; animation: pr-click .6s ease-out forwards; }
			@keyframes pr-click { from { transform: scale(.3); opacity: 1; } to { transform: scale(1.4); opacity: 0; } }
			#pr-keys { position: fixed; z-index: 2147483647; left: 50%; bottom: 24px; transform: translateX(-50%); padding: 6px 14px; border-radius: 8px; background: rgba(17, 24, 39, .9); color: #fff; font: 600 16px system-ui, sans-serif; pointer-events: none; opacity: 0; transition: opacity .2s; }
		`;
		const cursor = document.createElement("div");
		cursor.id = "pr-cursor";
		const keys = document.createElement("div");
		keys.id = "pr-keys";
		let hideKeys: number | undefined;

		window.addEventListener("DOMContentLoaded", () => document.body.append(style, cursor, keys));
		window.addEventListener("mousemove", (event) => {
			cursor.style.left = `${event.clientX}px`;
			cursor.style.top = `${event.clientY}px`;
		}, true);
		window.addEventListener("mousedown", (event) => {
			cursor.classList.add("pressed");
			const ring = document.createElement("div");
			ring.className = "pr-click";
			ring.style.left = `${event.clientX}px`;
			ring.style.top = `${event.clientY}px`;
			document.body.append(ring);
			setTimeout(() => ring.remove(), 600);
		}, true);
		window.addEventListener("mouseup", () => cursor.classList.remove("pressed"), true);
		window.addEventListener("keydown", (event) => {
			const modifiers = [event.metaKey && "⌘", event.ctrlKey && "Ctrl", event.altKey && "Alt", event.shiftKey && "Shift"].filter(Boolean);
			const isShortcut = modifiers.length > 0 || event.key.length > 1;
			if (!isShortcut) {
				return;
			}
			keys.textContent = [...modifiers, event.key === " " ? "Space" : event.key].join(" + ");
			keys.style.opacity = "1";
			clearTimeout(hideKeys);
			hideKeys = window.setTimeout(() => (keys.style.opacity = "0"), 1200);
		}, true);
	});
}
```

## Move, click and type at a human pace

Playwright moves the mouse in one jump. Move it in steps so the reviewer sees where it goes, and wait after each action:

```ts
import type { Locator, Page } from "@playwright/test";

const pauseAfterAction = 1000;

export async function clickVisibly(page: Page, target: Locator): Promise<void> {
	await target.scrollIntoViewIfNeeded();
	const box = await target.boundingBox();
	if (!box) {
		throw new Error("The target is not visible");
	}
	await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2, { steps: 25 });
	await page.waitForTimeout(300);
	await target.click();
	await page.waitForTimeout(pauseAfterAction);
}

export async function typeVisibly(page: Page, field: Locator, text: string): Promise<void> {
	await clickVisibly(page, field);
	await field.pressSequentially(text, { delay: 80 });
	await page.waitForTimeout(pauseAfterAction);
}
```

## Record

```ts
const context = await browser.newContext({
	viewport: { width: 1440, height: 900 },
	recordVideo: { dir: `${process.env.TMPDIR}/pr-evidence/video`, size: { width: 1440, height: 900 } },
});
await showPointerAndKeys(context);
const page = await context.newPage();
await page.goto("http://localhost:3000/pricing");
await page.waitForTimeout(1000);
await clickVisibly(page, page.getByRole("tab", { name: "Annual" }));
await context.close();
```

- Wait 1 s on the first screen, so the reviewer sees the starting state.
- Close the context to write the video file.
- For mobile, use `viewport: { width: 390, height: 844 }`, `isMobile: true` and `hasTouch: true`, and the same size in `recordVideo`.

## Convert

Playwright writes WebM. Convert it to MP4 so that every browser plays it:

```bash
ffmpeg -i "$TMPDIR/pr-evidence/video/<file>.webm" -c:v libx264 -pix_fmt yuv420p -movflags +faststart "$TMPDIR/pr-evidence/after-flow.mp4"
```

For a short flow inside the text, make a GIF:

```bash
ffmpeg -i "$TMPDIR/pr-evidence/after-flow.mp4" -vf "fps=12,scale=900:-1:flags=lanczos,split[a][b];[a]palettegen[p];[b][p]paletteuse" "$TMPDIR/pr-evidence/after-flow.gif"
```

## Before and after

- If the flow changes, record each side with the same script, on the base branch and on the branch.
- To put both sides next to each other in one video:

```bash
ffmpeg -i before-flow.mp4 -i after-flow.mp4 -filter_complex "[0:v][1:v]hstack=inputs=2" -c:v libx264 -pix_fmt yuv420p before-after-flow.mp4
```

## In the body

Write one sentence above each video with the steps that it shows and its duration. A video has no alt text, so the sentence is the only description:

```markdown
Open the pricing page, select Annual and apply the BLACKFRIDAY coupon (24 s):

VIDEO_AFTER_FLOW
```

GitHub renders a video as a player only when its URL is alone on a line. gh appends a video that the body does not reference at the end of the body. To put it under its sentence:

1. Write a placeholder line, for example `VIDEO_AFTER_FLOW`, where the video goes.
2. Run `gh pr create` or `gh pr edit` with `--attach` for the video.
3. Read the body with `gh pr view --json body --jq .body`. Move each appended `https://github.com/user-attachments/assets/…` line to the line of its placeholder.
4. Apply it with `gh pr edit --body-file`.
