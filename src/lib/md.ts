import { marked } from 'marked';

// Turns a CMS text body into paragraphs of inline HTML. The CMS editor is
// limited to bold, italic and links, so block-level Markdown isn't expected.
// Pages render each paragraph as their own <p set:html>, which keeps scoped
// component styles applying to the <p> elements. A single line break inside a
// paragraph becomes a <br>.
export function paragraphs(md: string): string[] {
  return md
    .split(/\n\s*\n/)
    .map((p) => p.trim())
    .filter(Boolean)
    .map((p) => marked.parseInline(p, { breaks: true }) as string);
}
