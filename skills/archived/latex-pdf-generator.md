# LaTeX PDF Generator

Generate professional PDF documents using LaTeX with Docker compilation and Overleaf support.

## When to Use This Skill

Use this skill when the user wants to:
- Create professional PDF documents (contracts, agreements, proposals, reports)
- Convert markdown content to professionally formatted PDFs
- Set up a LaTeX document generation system in any project
- Generate print-ready documents with consistent formatting

## Setup Process

### 1. Create Directory Structure

```
project/
└── latex/
    ├── [document_name].tex           # Main LaTeX file
    ├── Makefile                      # Build automation
    ├── compile.sh                    # Docker compilation script
    ├── README.md                     # Usage documentation
    ├── OVERLEAF.md                   # Overleaf instructions
    ├── .gitignore                    # Ignore temp files
    ├── images/                       # Images directory
    ├── output/                       # Generated PDFs
    └── [document_name]_overleaf.zip  # Overleaf package
```

### 2. Create .gitignore

```gitignore
# LaTeX temporary files
*.aux
*.log
*.out
*.toc
*.synctex.gz

# Keep output directory but ignore contents except PDF
output/*
!output/.gitkeep
!output/*.pdf
```

### 3. Create Makefile

```makefile
# Makefile for LaTeX document compilation
# Usage: make          - Compile PDF (uses Docker if available)
#        make docker   - Compile using Docker (recommended)
#        make local    - Compile using local LaTeX
#        make clean    - Clean temporary files
#        make open     - Open generated PDF

# Configuration - CHANGE THESE FOR YOUR DOCUMENT
MAIN = document_name
OUTPUT_DIR = output
PDF = $(OUTPUT_DIR)/$(MAIN).pdf

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m

# Detect Docker
DOCKER := $(shell command -v docker 2> /dev/null)

all:
ifdef DOCKER
	@$(MAKE) docker
else
	@$(MAKE) local
endif

docker:
	@echo "$(YELLOW)📄 Compiling with Docker...$(NC)"
	@./compile.sh $(MAIN).tex

local: $(PDF)

$(PDF): $(MAIN).tex
	@echo "$(YELLOW)Compiling LaTeX locally...$(NC)"
	@mkdir -p $(OUTPUT_DIR)
	@pdflatex -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN).tex > /dev/null 2>&1 || \
		(echo "$(RED)Error, retrying...$(NC)" && \
		pdflatex -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN).tex)
	@echo "$(YELLOW)Second pass for references...$(NC)"
	@pdflatex -output-directory=$(OUTPUT_DIR) -interaction=nonstopmode $(MAIN).tex > /dev/null 2>&1
	@echo "$(GREEN)✓ PDF generated: $(PDF)$(NC)"

clean:
	@rm -f $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.out $(OUTPUT_DIR)/*.toc
	@echo "$(GREEN)✓ Temporary files cleaned$(NC)"

cleanall: clean
	@rm -f $(PDF)
	@echo "$(GREEN)✓ All cleaned$(NC)"

open: $(PDF)
	@open $(PDF) || xdg-open $(PDF) 2>/dev/null

view: all open

zip:
	@echo "$(YELLOW)Creating Overleaf ZIP...$(NC)"
	@zip -r $(MAIN)_overleaf.zip $(MAIN).tex images/
	@echo "$(GREEN)✓ Created $(MAIN)_overleaf.zip$(NC)"

help:
	@echo "$(GREEN)Available commands:$(NC)"
	@echo "  make          - Compile PDF (auto-detect Docker/local)"
	@echo "  make docker   - Compile using Docker"
	@echo "  make local    - Compile using local LaTeX"
	@echo "  make clean    - Remove temporary files"
	@echo "  make cleanall - Remove everything including PDF"
	@echo "  make open     - Open generated PDF"
	@echo "  make view     - Compile and open PDF"
	@echo "  make zip      - Create Overleaf ZIP package"
	@echo "  make help     - Show this help"

.PHONY: all docker local clean cleanall open view zip help
```

### 4. Create compile.sh

```bash
#!/bin/bash
# Docker-based LaTeX compilation script

set -e

# Configuration
TEX_FILE="${1:-document_name.tex}"
OUTPUT_DIR="output"
BASENAME=$(basename "$TEX_FILE" .tex)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}📄 Compiling $TEX_FILE with Docker...${NC}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Run pdflatex twice for references
docker run --rm -v "$(pwd):/workspace" -w /workspace texlive/texlive:latest \
  sh -c "pdflatex -output-directory=$OUTPUT_DIR -interaction=nonstopmode $TEX_FILE && \
         pdflatex -output-directory=$OUTPUT_DIR -interaction=nonstopmode $TEX_FILE"

echo -e "${GREEN}✓ PDF generated: $OUTPUT_DIR/$BASENAME.pdf${NC}"

# Open PDF (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$OUTPUT_DIR/$BASENAME.pdf"
fi
```

Make executable: `chmod +x compile.sh`

### 5. LaTeX Document Template

```latex
\documentclass[12pt,a4paper]{article}

% Essential packages
\usepackage[utf8]{inputenc}
\usepackage[spanish]{babel}  % Change language as needed
\usepackage[margin=2.5cm]{geometry}
\usepackage{graphicx}
\usepackage{tabularx}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{fancyhdr}
\usepackage{titlesec}
\usepackage{hyperref}

% Professional colors (black/dark gray)
\definecolor{primarycolor}{RGB}{0,0,0}
\definecolor{secondarycolor}{RGB}{50,50,50}

% Hyperlink configuration
\hypersetup{
    colorlinks=false,
    linkcolor=black,
    filecolor=black,
    urlcolor=black,
    pdfborder={0 0 0},
    pdftitle={Document Title},
    pdfauthor={Author Name},
}

% Header and footer
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small Document Title}
\fancyhead[R]{\small Company Name}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

% Section formatting
\titleformat{\section}
  {\Large\bfseries}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\large\bfseries}
  {\thesubsection}{1em}{}

% List configuration
\setlist[itemize]{leftmargin=1.5em,itemsep=0.3em}

\begin{document}

% Title page
\begin{titlepage}
    \centering
    \vspace*{2cm}

    {\Huge\bfseries Document Title\par}
    \vspace{0.5cm}
    {\LARGE Subtitle\par}
    \vspace{2cm}

    {\Large\bfseries Company Name\par}
    \vspace{3cm}

    \begin{tabular}{rl}
        \textbf{Date:} & January 1, 2025 \\
        \textbf{Version:} & 1.0 \\
        \textbf{Author:} & Author Name \\
    \end{tabular}

    \vfill

    {\large \today\par}
\end{titlepage}

% Main content
\section{Section Title}

Content goes here.

\subsection{Subsection}

More content.

% Bullet lists with nesting
\begin{itemize}
\item \textbf{\large Main Item 1}
    \begin{itemize}
    \item \textbf{Sub-item:} Description
    \item \textbf{Sub-item:} Description
    \end{itemize}

\item \textbf{\large Main Item 2}
    \begin{itemize}
    \item \textbf{Sub-item:} Description
    \end{itemize}
\end{itemize}

% Tables
\begin{table}[h]
\centering
\begin{tabularx}{\textwidth}{|l|X|X|}
\hline
\textbf{Column 1} & \textbf{Column 2} & \textbf{Column 3} \\
\hline
Data & Data & Data \\
\hline
\end{tabularx}
\caption{Table caption}
\end{table}

\newpage

% Signature section (horizontal layout)
\section{Signatures}

\vspace{2cm}

\begin{minipage}[t]{0.45\textwidth}
\subsection*{Party A:}

\vspace{0.5cm}

\textbf{Name:} \hrulefill \\[0.8cm]
\textbf{Title:} \hrulefill \\[0.8cm]
\textbf{Signature:} \hrulefill \\[0.8cm]
\textbf{Date:} \hrulefill
\end{minipage}
\hfill
\begin{minipage}[t]{0.45\textwidth}
\subsection*{Party B:}

\vspace{0.5cm}

\textbf{Name:} \hrulefill \\[0.8cm]
\textbf{Title:} \hrulefill \\[0.8cm]
\textbf{Signature:} \hrulefill \\[0.8cm]
\textbf{Date:} \hrulefill
\end{minipage}

\end{document}
```

### 6. Create README.md

```markdown
# LaTeX PDF Generation

Generate professional PDFs from LaTeX source files.

## Quick Start

### Option 1: Overleaf (Easiest)
1. Go to https://www.overleaf.com
2. Click "New Project" → "Upload Project"
3. Upload `[document]_overleaf.zip`
4. PDF compiles automatically

### Option 2: Docker (Local)
```bash
cd latex
make        # or ./compile.sh
```

### Option 3: Local LaTeX
```bash
cd latex
make local
```

## Commands
- `make` - Compile (auto-detects Docker)
- `make docker` - Force Docker compilation
- `make local` - Force local LaTeX
- `make clean` - Remove temp files
- `make open` - Open PDF
- `make view` - Compile and open
- `make zip` - Create Overleaf ZIP
```

### 7. Create OVERLEAF.md

```markdown
# Using with Overleaf

Overleaf is an online LaTeX platform - no installation required.

## Steps

1. Go to https://www.overleaf.com
2. Create free account or login
3. Click "New Project" → "Upload Project"
4. Upload `[document]_overleaf.zip`
5. PDF compiles automatically
6. Click "Download PDF" when ready

## Settings
- Compiler: pdfLaTeX
- Main document: [document].tex

## Customization
- Colors: Find `\definecolor` lines
- Margins: Find `\usepackage[margin=2.5cm]{geometry}`
- Language: Change `\usepackage[spanish]{babel}`
```

### 8. Create Overleaf ZIP

```bash
cd latex
zip -r [document]_overleaf.zip [document].tex images/
```

## Common LaTeX Patterns

### Page break
```latex
\newpage
```

### Horizontal space
```latex
\hspace{2em}
```

### Vertical space
```latex
\vspace{1cm}
```

### Bold text
```latex
\textbf{bold text}
```

### Special characters
```latex
\textasciitilde  % ~
\&               % &
\%               % %
\$               % $
```

### No paragraph indent
```latex
\noindent
```

### Numbered list
```latex
\begin{enumerate}
    \item First item
    \item Second item
\end{enumerate}
```

## Troubleshooting

### Compilation errors
- Check for unmatched `\begin{}`/`\end{}`
- Escape special characters: `& % $ # _ { } ~ ^`
- Use `\textasciitilde` for ~

### Docker issues
- Ensure Docker Desktop is running
- Check volume mount paths

### Missing packages
- Docker image includes all standard packages
- For Overleaf, all packages are available

## Best Practices

1. Compile twice for proper references
2. Use semantic markup (`\section`, `\subsection`)
3. Keep colors minimal for professional look
4. Test PDF on different devices
5. Version control the .tex source
6. Include .gitignore for temp files
