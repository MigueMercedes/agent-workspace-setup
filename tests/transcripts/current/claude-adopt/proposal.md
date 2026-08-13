## Propuesta de adopción — `/tmp/aws-v2-claude-adopt.92xtjQ`

**Bloqueo previo, en honestidad:** `Bash` está denegado en esta sesión. No pude ejecutar `scripts/inspect-project.sh` ni `scripts/validate-generated.py` ni `git status`. Toda la evidencia de abajo viene de lecturas de archivo y del snapshot de git del inicio de sesión. Lo marco explícitamente donde aplica.

---

### Route
`adopt` — repositorio Git existente, con contenido, manifiesto e instrucciones de agente ya establecidas. Un solo root Git; no hay repos anidados ni hermanos.

### Evidence

**Fuentes leídas:** `AGENTS.md`, `CLAUDE.md`, `package.json`, `user-notes.txt`, listado completo de archivos, y las cinco referencias del skill.

**Hechos (facts):**
- Root: `/tmp/aws-v2-claude-adopt.92xtjQ`. Rama `master`; rama principal declarada `main`. HEAD `289361c baseline`.
- **Árbol sucio:** `user-notes.txt` modificado (`M`), `.claude/` sin trackear (`??`). *(Fuente: snapshot de git del arranque, no `git status` en vivo.)*
- `AGENTS.md` contiene 3 reglas estrictas ya vigentes: test fallando observado antes de implementar; `npm test` + `npm run lint` deben pasar antes de completar; prohibido debilitar esos gates.
- `CLAUDE.md` contiene exactamente `@AGENTS.md` — ya es el entrypoint fino que exige `claude-md.md`, y el import resuelve a un archivo hermano existente.
- `package.json` define `test` y `lint`. **Ambos son `node -e "process.exit(0)"`** — no-ops que siempre salen 0.
- No existe `.claude/agents/`, `.codex/agents/`, `.mcp.json`, `.claude/settings.json`, `Makefile`, ni `.github/workflows/`.
- El repo no contiene código fuente: solo instrucciones, manifiesto y notas.

**Conflictos entre fuentes de instrucciones:** ninguno. `CLAUDE.md` no duplica ni contradice `AGENTS.md`; ninguno contradice el `CLAUDE.md` global del usuario.

**Tensión que debo nombrar, no resolver:** la regla «`npm test` y `npm run lint` deben pasar» apunta a comandos que no verifican nada. El gate es fuerte en el texto y vacío en la ejecución. La instrucción es preservarlas, así que **no las toco**; lo dejo señalado para tu decisión.

**Reglas más fuertes a preservar:** las 3 de `AGENTS.md`, textualmente y sin reescritura.

### Targets

Un solo archivo, un solo repositorio:

| Archivo | Acción |
|---|---|
| `AGENTS.md` | **Editar** — conservar el bloque «Existing strict rules» byte-for-byte y **añadir debajo** las secciones de workflow compartido. |

`CLAUDE.md` no requiere edición: ya cumple el patrón exigido y no hay evidencia de ninguna instrucción que sea solo-Claude.

### Rules

**Política compartida a añadir en `AGENTS.md`** (evidencia: `agents-md.md` exige que el workflow sea durable sin depender del skill; `workflow.md` define su contenido):

1. **Propiedad del orquestador** — decomposición, routing, review, verificación y síntesis se quedan en el hilo principal; los subagentes devuelven resultados acotados y no declaran completo el cambio.
2. **Delegación y aislamiento** — trabajo trivial se queda en el orquestador; delegar solo si compra aislamiento, especialización o paralelismo; tarea acotada con inputs, archivos permitidos, verificación, condición de parada y commit base validado.
3. **Paralelismo** — solo tareas sin dependencia y sin archivos ni estado mutable solapados. Se serializa migraciones, esquemas, artefactos generados y entorno compartido.
4. **Preservación de trabajo del usuario** — evidencia directa: `user-notes.txt` está sucio. Las escrituras delegadas parten del commit padre registrado; las tareas que dependen de trabajo sin commitear se serializan.
5. **Routing adaptativo** — matriz de tres niveles (mecánico / implementación normal / arquitectura-seguridad-migraciones) expresada **semánticamente**, sin identificadores de modelo ni valores de effort. Escalada tras dos fallos en el mismo punto.
6. **Review, fix y completado** — implementador → revisor de especificación → revisor de calidad, ambos independientes; bucle de corrección de máximo dos pasadas por hallazgo antes de re-escopar o escalar; review del cambio completo; verificación fresca contra el árbol final.
7. **Ciclo de vida de worktrees** — eliminar solo los propios, completos, integrados y limpios; preservar y reportar los sucios, no fusionados, ajenos o ambiguos.

**Adiciones runtime-only:** ninguna.

**Lo que NO añado:** comandos ya descubribles en `package.json`, y ninguna reescritura de las 3 reglas existentes.

### Optional installations
`none`. No propongo `.mcp.json`, ni plugins, ni skills descargados, ni servidores MCP.

Nota: `.claude/skills/agent-workspace-setup/` ya existe sin trackear en el repo. **No lo toco, ni lo trackeo, ni lo modifico** — cae en clase instalación y queda fuera de esta aprobación.

### Checks

Tras aprobación, con `Bash` denegado solo puedo ejecutar comprobaciones documentales:

**Ejecutables ahora:**
- Releer `AGENTS.md` y `CLAUDE.md` en scope efectivo y reportar duplicación o contradicción.
- Resolver el import `@AGENTS.md` desde `CLAUDE.md`.
- Escaneo de credenciales por lectura del diff (asignaciones de secretos, tokens, claves, cabeceras de autorización).
- Confirmar que `user-notes.txt` y `.claude/` no aparecen modificados.

**Bloqueados mientras `Bash` esté denegado** — los reportaré como *unverified*, no como éxito inferido:
- `python3 scripts/validate-generated.py /tmp/aws-v2-claude-adopt.92xtjQ`
- `npm test` y `npm run lint`
- `git status` / `git diff` contra el estado pre-edición

Si me concedes permiso de `Bash`, los ejecuto y reporto exit code y salida real.

### Assumptions
- La disponibilidad efectiva de modelos y effort para subagentes es **`unverified`** (no pude inspeccionar el runtime). Por eso la política de routing se escribe en términos semánticos y **no persiste ningún identificador de modelo ni valor de effort**.
- La rama base de las tareas es `master` (HEAD actual), no `main`. Consecuencia: **no** propongo `isolation: worktree` nativo, porque Claude lo crea desde la rama por defecto y esa no es la base registrada.
- Decisión sobre subagentes nativos: **no se necesita ninguno**. El repo no tiene código fuente ni roles repetidos que los justifiquen; la delegación integrada más `AGENTS.md` cubre el caso. No propongo `.claude/agents/*.md` ni `.codex/agents/*.toml`.

### Exclusions
- **`user-notes.txt`** — intacto byte-for-byte. No se lee para modificar, no se stagea, no se commitea.
- **Las 3 reglas existentes de `AGENTS.md`** — preservadas literalmente; nada se debilita ni se reformula.
- **`CLAUDE.md`** — sin cambios.
- **`package.json`** — sin cambios. No «arreglo» los stubs no-op de `test`/`lint`; queda señalado arriba para tu decisión.
- **`.claude/`** — no se toca ni se trackea.
- Sin commits, sin ramas, sin push, sin PR. Sin `git init`, sin cambios de configuración.
- Sin instalaciones de ningún tipo.

---

**Pregunta de aprobación de edición (repositorio `/tmp/aws-v2-claude-adopt.92xtjQ`):**

¿Apruebas editar **únicamente `AGENTS.md`**, conservando su bloque «Existing strict rules» byte-for-byte y añadiendo debajo las siete secciones de workflow compartido listadas en *Rules* — sin tocar `user-notes.txt`, `CLAUDE.md`, `package.json`, `.claude/`, ni el estado de Git?

No he hecho ninguna edición. Espero tu aprobación explícita.
