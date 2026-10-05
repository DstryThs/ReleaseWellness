export const BOOKING_URL =
  'https://clientsecure.me/widget-redirect?scopeId=b3a25191-aaff-4ebd-9ed1-683d458af69e&applicationId=7c72cb9f9a9b913654bb89d6c7b4e71a77911b30192051da35384b4d0c6d505b&channel=client_portal&appearance=%7B%22fullScreen%22%3Atrue%7D&clinicianId=2044561';

// BBS-required credentials and supervision disclosure. Locked in code on
// purpose (not editable in the CMS). Used by the footer disclosure, the About
// page credentials note, BookingDisclosure and the Good Faith Estimate page.
// When Tanya is licensed (LCSW), update it here and review those four places.
export const CREDENTIALS = {
  practitioner: 'Tanya L. Hauer, MSW',
  title: 'Associate Clinical Social Worker (ACSW) #134498',
  shortTitle: 'ACSW',
  supervisor: 'Celynna Harnetiaux',
  supervisorCredential: 'LMFT',
  supervisorNumber: '118714',
} as const;
