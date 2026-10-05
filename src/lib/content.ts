import { getEntry, type CollectionEntry, type CollectionKey } from 'astro:content';

// Each editable page is a one-entry collection (src/content.config.ts) whose
// entry id matches the collection name, e.g. src/content/pages/home.yaml.
export async function getPage<C extends CollectionKey>(name: C): Promise<CollectionEntry<C>['data']> {
  const entry = (await getEntry(name as any, name)) as CollectionEntry<C> | undefined;
  if (!entry) throw new Error(`Missing content file: src/content/pages/${name}.yaml`);
  return entry.data;
}

// Contact details and social links (CMS: "Contact & Social").
export const getContact = () => getPage('settings');

// "(949) 687-3899" -> "tel:+19496873899"
export function telHref(phone: string): string {
  const digits = phone.replace(/\D/g, '');
  return `tel:+${digits.length === 10 ? `1${digits}` : digits}`;
}
