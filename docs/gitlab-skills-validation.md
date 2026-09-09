# Validación de las skills de GitLab

Guía para probar `codely-plan-create-gitlab` y `codely-plan_phase-implement-gitlab` en un proyecto del GitLab interno de la organización. Prerequisito: `glab` instalado y autenticado contra el host del GitLab interno (`glab auth login --hostname <gitlab-host>`; comprobar con `glab auth status`).

## 1. Instalar las skills donde va a ejecutarse la prueba

Las skills solo se cargan si están en el proyecto (o globalmente). Dos opciones:

- **Global** (recomendada para probar en varios proyectos): copiar los 2 folders (`codely-plan-create-gitlab/`, `codely-plan_phase-implement-gitlab/`) al directorio global de skills del usuario (`~/.agents/skills/`)
- **Por proyecto**: copiarlos en `<proyecto-interno>\.agents\skills\`

## 2. Probar `codely-plan-create-gitlab`

1. Clonar el proyecto interno y crear una issue de prueba en él (o usar un proyecto desechable "sandbox").
2. Desde el clone ejecutar: `/codely-plan-create-gitlab <url-de-la-issue>`
3. Verificar:
   - Las issues hijas se crean con `Part of #<parent>` y sus checkboxes.
   - En la issue padre aparece la sección **Related issues** con las hijas (el link `relates_to` es lo primero que fallaría).
   - El body del padre conserva la descripción original + checklist `Phases` + footer de metadata.

## 3. Probar `codely-plan_phase-implement-gitlab`

1. Ejecutar: `/codely-plan_phase-implement-gitlab <url-del-padre>`
2. Verificar:
   - Resuelve la fase actual (primera hija abierta).
   - Crea branch `<iid>-<slug>`, MR con `Closes #<iid>`.
   - El checklist del padre se marca manualmente (`- [x] #<child>`).
3. **Mergear una MR** para confirmar que la hija se cierra sola; con la última fase, que se cierra también el padre.

## 4. Riesgos a observar en self-hosted

- Que `glab` resuelva bien la URL de las issues del self-hosted: `https://<gitlab-host>/<grupo>/<proyecto>/-/issues/<iid>`.
- El flag `--linked-issues` de `glab issue create` contra esa instancia.
