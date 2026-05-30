// OpenCode plugin: blocks the `export` command to prevent environment-variable
// exfiltration. OpenCode-native equivalent of the .cursor / .github block-export
// hooks. Auto-loaded at startup from .opencode/plugins/ (no registration needed).
//
// Unlike the declarative matchers, the logic lives here, so we use a word-boundary
// regex to avoid false positives (e.g. "report", "exporter").
export const BlockExport = async () => {
  return {
    "tool.execute.before": async (input: any, output: any) => {
      const command: string = output?.args?.command ?? "";
      if (input.tool === "bash" && /\bexport\b/.test(command)) {
        throw new Error(
          "Blocked: the export command is not allowed by security policy",
        );
      }
    },
  };
};
