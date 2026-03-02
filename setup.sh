#!/bin/bash
#
# Claude Multi-Agent Setup Script
# 프로젝트 디렉토리에 멀티 에이전트를 설치합니다.
#
# 사용법:
#   ./setup.sh                     # 현재 디렉토리에 설치
#   ./setup.sh /path/to/project    # 지정 디렉토리에 설치
#   ./setup.sh --symlink /path     # 심링크로 설치 (이 리포와 동기화)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$SCRIPT_DIR/.claude/agents"
STRATEGY_SRC="$SCRIPT_DIR/.claude/STRATEGY-TEMPLATE.md"
GUIDE_SRC="$SCRIPT_DIR/.claude/AGENT-GUIDE.md"

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Claude Multi-Agent Setup (14 Agents)   ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

# 인자 파싱
USE_SYMLINK=false
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --symlink|-s)
            USE_SYMLINK=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--symlink] [target_directory]"
            echo ""
            echo "Options:"
            echo "  --symlink, -s    Use symlinks instead of copying (stays in sync)"
            echo "  --help, -h       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                          # Install to current directory"
            echo "  $0 /home/user/my-project    # Install to specific directory"
            echo "  $0 --symlink /home/user/work # Install as symlinks"
            exit 0
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# 타겟 디렉토리 결정
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR="$(pwd)"
fi

TARGET_CLAUDE="$TARGET_DIR/.claude"
TARGET_AGENTS="$TARGET_CLAUDE/agents"

print_header

echo "Source:  $SCRIPT_DIR"
echo "Target:  $TARGET_DIR"
echo "Mode:    $([ "$USE_SYMLINK" = true ] && echo "Symlink" || echo "Copy")"
echo ""

# 소스 확인
if [ ! -d "$AGENTS_SRC" ]; then
    echo "Error: Agent source directory not found: $AGENTS_SRC"
    exit 1
fi

AGENT_COUNT=$(ls -1 "$AGENTS_SRC"/*.md 2>/dev/null | wc -l)
echo "Agents found: $AGENT_COUNT"
echo ""

# .claude 디렉토리 생성
mkdir -p "$TARGET_CLAUDE"

# 에이전트 설치
if [ "$USE_SYMLINK" = true ]; then
    # 기존 agents 디렉토리/심링크 제거
    if [ -e "$TARGET_AGENTS" ] || [ -L "$TARGET_AGENTS" ]; then
        print_info "Removing existing agents directory..."
        rm -rf "$TARGET_AGENTS"
    fi
    ln -s "$AGENTS_SRC" "$TARGET_AGENTS"
    print_success "Agents symlinked: $TARGET_AGENTS → $AGENTS_SRC"

    # 전략 템플릿
    if [ -f "$STRATEGY_SRC" ]; then
        if [ -e "$TARGET_CLAUDE/STRATEGY-TEMPLATE.md" ] || [ -L "$TARGET_CLAUDE/STRATEGY-TEMPLATE.md" ]; then
            rm -f "$TARGET_CLAUDE/STRATEGY-TEMPLATE.md"
        fi
        ln -s "$STRATEGY_SRC" "$TARGET_CLAUDE/STRATEGY-TEMPLATE.md"
        print_success "Strategy template symlinked"
    fi

    # 가이드
    if [ -f "$GUIDE_SRC" ]; then
        if [ -e "$TARGET_CLAUDE/AGENT-GUIDE.md" ] || [ -L "$TARGET_CLAUDE/AGENT-GUIDE.md" ]; then
            rm -f "$TARGET_CLAUDE/AGENT-GUIDE.md"
        fi
        ln -s "$GUIDE_SRC" "$TARGET_CLAUDE/AGENT-GUIDE.md"
        print_success "Agent guide symlinked"
    fi
else
    # 복사 모드
    mkdir -p "$TARGET_AGENTS"
    cp "$AGENTS_SRC"/*.md "$TARGET_AGENTS/"
    print_success "Agents copied to $TARGET_AGENTS/ ($AGENT_COUNT files)"

    # 전략 템플릿
    if [ -f "$STRATEGY_SRC" ]; then
        cp "$STRATEGY_SRC" "$TARGET_CLAUDE/"
        print_success "Strategy template copied"
    fi

    # 가이드
    if [ -f "$GUIDE_SRC" ]; then
        cp "$GUIDE_SRC" "$TARGET_CLAUDE/"
        print_success "Agent guide copied"
    fi
fi

# 결과 출력
echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Installed agents:"
ls -1 "$TARGET_AGENTS"/*.md 2>/dev/null | while read f; do
    name=$(basename "$f" .md)
    echo "  - $name"
done
echo ""
echo "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. claude                    # Start Claude Code"
echo "  3. Ask anything — agents are auto-loaded!"
echo ""
if [ "$USE_SYMLINK" = true ]; then
    echo "Tip: Symlink mode — update the source repo to sync all projects:"
    echo "  cd $SCRIPT_DIR && git pull"
fi
