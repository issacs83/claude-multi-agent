# Claude Multi-Agent Base Template

Claude Code용 **14개 전문 에이전트** 베이스 템플릿입니다.
프로젝트에 복사하면 즉시 멀티 에이전트 시스템을 사용할 수 있습니다.

## Quick Start

```bash
# 1. 클론
git clone https://github.com/issacs83/claude-multi-agent.git

# 2. 프로젝트에 설치
./claude-multi-agent/setup.sh /path/to/your/project

# 3. Claude Code 실행
cd /path/to/your/project
claude
```

## 14 Agents

| Category | Agent | Model | Focus |
|----------|-------|-------|-------|
| **Strategy** | product-strategist | opus | Roadmap, competitive analysis, milestones |
| | regulatory-specialist | opus | FDA, CE, ISO, IEC compliance |
| **Hardware** | hardware-engineer | opus | Optics, sensors, thermal, mechanical |
| | circuit-engineer | opus | Schematic, PCB, power, SI, EMC |
| **Embedded** | bsp-engineer | sonnet | Yocto, kernel, DTS, U-Boot |
| | firmware-engineer | opus | MCU, FPGA, Cortex-M, RTOS |
| **Algorithm/3D** | algorithm-researcher | opus | CV, ML, signal processing, optimization |
| | graphics-engineer | opus | Metal, Vulkan, WebGL, 3D rendering |
| **Software** | sdk-developer | opus | Cross-platform SDK, driver abstraction |
| | web-developer | sonnet | React, API, DB, full-stack |
| **Quality/Ops** | qa-tester | sonnet | Testing, V&V, benchmarks |
| | devops-engineer | sonnet | CI/CD, builds, releases |
| | doc-writer | sonnet | Technical docs, regulatory docs |
| | maintenance-engineer | sonnet | Crash analysis, field support, OTA |

## Installation Methods

### Copy (independent per project)
```bash
./setup.sh /path/to/project
```

### Symlink (stays in sync with this repo)
```bash
./setup.sh --symlink /path/to/project
```

### Manual
```bash
mkdir -p /your/project/.claude/agents
cp .claude/agents/*.md /your/project/.claude/agents/
```

## Usage

Just talk naturally — the orchestrator routes to the right agent:

```
You: "커널에 SPI 드라이버 패치 추가해줘"
→ bsp-engineer handles it

You: "FDA 510(k) 전략 수립"
→ regulatory-specialist handles it

You: "포인트 클라우드 렌더링 최적화"
→ graphics-engineer handles it
```

Or specify an agent directly:

```
You: "firmware-engineer로 하드폴트 분석해줘"
```

## Customization

- **Edit agents**: Modify `.claude/agents/*.md` files
- **Add agents**: Create new `.md` file in `.claude/agents/`
- **Remove agents**: Delete or move the `.md` file
- **Project strategy**: Copy and customize `STRATEGY-TEMPLATE.md`

See [AGENT-GUIDE.md](.claude/AGENT-GUIDE.md) for detailed documentation.

## File Structure

```
claude-multi-agent/
├── README.md                         ← This file
├── setup.sh                          ← Installation script
└── .claude/
    ├── AGENT-GUIDE.md                ← Detailed usage guide
    ├── STRATEGY-TEMPLATE.md          ← Project strategy template
    └── agents/                       ← 14 agent definitions
        ├── product-strategist.md
        ├── algorithm-researcher.md
        ├── bsp-engineer.md
        ├── firmware-engineer.md
        ├── hardware-engineer.md
        ├── circuit-engineer.md
        ├── graphics-engineer.md
        ├── sdk-developer.md
        ├── web-developer.md
        ├── qa-tester.md
        ├── regulatory-specialist.md
        ├── devops-engineer.md
        ├── doc-writer.md
        └── maintenance-engineer.md
```

## License

MIT
