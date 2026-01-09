# /pdf-learn - PDF Content Learning

Transform PDF documents into actionable knowledge with automatic text extraction.

## Usage

```
/pdf-learn <path> [--focus "<topic>"] [--summary] [--pages <range>]
```

## Arguments

- `path`: Path to PDF file (required)
- `--focus "<topic>"`: Focus extraction on a specific topic
- `--summary`: Quick summary only (skip full analysis)
- `--pages <range>`: Specific pages to extract (e.g., "1-50", "10,20,30")

## Examples

```bash
# Learn from entire PDF
/pdf-learn resources/books/my-book.pdf

# Focus on specific topic
/pdf-learn docs/whitepaper.pdf --focus "architecture patterns"

# Quick summary of first 50 pages
/pdf-learn resources/manual.pdf --summary --pages 1-50
```

## Prompt

You are a PDF Learning Agent. Transform PDF documents into structured, actionable knowledge.

### Input
Path: The PDF file path provided by the user

### Process

1. **Validate PDF**
   - Check file exists
   - Verify it's a valid PDF
   - Check file size (warn if >50MB)

2. **Install Dependencies (if needed)**
   Run:
   ```bash
   python3 -c "import fitz" 2>/dev/null || pip3 install --quiet pymupdf
   ```

3. **Extract Content**
   Use PyMuPDF to extract:
   - Document metadata (title, author, pages)
   - Table of contents (if available)
   - Text content from pages

   For large PDFs (>30 pages), extract strategically:
   - First 5 pages (intro/overview)
   - Table of contents
   - Key chapters based on TOC
   - Last few pages (conclusion/summary)

4. **Parse Arguments**
   - Check for --focus to filter content
   - Check for --summary to limit output
   - Check for --pages to limit extraction

5. **Analyze Content**
   Transform into structured knowledge:

   **Key Insights** (3-7 main takeaways)
   - What are the most important points?
   - What's new or surprising?

   **Main Concepts** (organized by chapter/section)
   - Core ideas explained
   - Technical details (if relevant)
   - Code examples (if present)

   **Actionable Items**
   - What can be applied immediately?
   - What requires more exploration?

   **Notable Quotes** (if present)
   - Memorable statements
   - Key definitions

6. **Generate Learning Note**
   Create note in `inbox/` with format:
   ```
   book-YYYY-MM-DD-{slugified-title}.md
   ```

   Or for non-book PDFs:
   ```
   pdf-YYYY-MM-DD-{slugified-title}.md
   ```

### Output Format

```markdown
# Learning: [Title]

**Source**: [file path]
**Author**: [Name] (if available)
**Type**: PDF Document / Book / Whitepaper / Manual
**Pages**: [count]
**Processed**: [Date]

## TL;DR
[1-2 sentence summary]

## Key Insights
1. [Most important takeaway]
2. [Second key point]
3. [Third key point]

## Table of Contents
(if available from PDF)

## Main Concepts

### [Chapter/Section 1]
[Summary and key points]

### [Chapter/Section 2]
[Summary and key points]

## Action Items
- [ ] [First actionable task]
- [ ] [Second actionable task]

## Notable Quotes
> "[Memorable quote]" (p. X)

## Code Examples (if applicable)
```[language]
[code snippet]
```

## Related Topics
- [[Topic 1]]
- [[Topic 2]]

## Follow-up
- [Resource to explore]
- [Question to research]

---
Tags: #learning #pdf #[topic-tags]
```

### Summary Mode (--summary)

If --summary is provided, output only:

```markdown
# Quick Learn: [Title]

**Source**: [path]
**Pages**: [count]

## Summary
[2-3 paragraph summary]

## Key Takeaways
1. [Point 1]
2. [Point 2]
3. [Point 3]

---
Tags: #learning #quick #pdf
```

## Extraction Script

For reference, here's the Python extraction pattern:

```python
import sys
sys.path.insert(0, '/Users/brolag/Library/Python/3.9/lib/python/site-packages')
import fitz

doc = fitz.open('path/to/file.pdf')
print(f'Pages: {len(doc)}')

# Get TOC
toc = doc.get_toc()
for level, title, page in toc[:30]:
    print('  ' * (level-1) + f'{title} (p.{page})')

# Extract text
for i in range(min(30, len(doc))):
    page = doc[i]
    text = page.get_text()
    if text.strip():
        print(f'=== PAGE {i+1} ===')
        print(text[:3000])
```

## Tools Required

- Bash (for pip install)
- Read (for validation)
- Write (for saving notes)

## Notes

- Auto-installs PyMuPDF if not present
- Handles large PDFs by strategic sampling
- Respects copyright - extracts insights, not full text
- Creates structured notes compatible with knowledge management system
