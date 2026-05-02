> **Note:** This file is the working brainstorm that preceded our final hosting decisions. The source of truth for the stack we're actually using is [hosting-decisions.md](hosting-decisions.md). Keep this around for context on how we got there.

---

I know that she registered her domain, but I don't know if she has a hosting plan.  
Thought for a couple of seconds

That’s normal. A **domain** and a **hosting plan** are separate things.

Domain \= the address  
Example: mysisterspractice.com

Hosting \= where the actual website files live  
Example: Squarespace, Webflow, Wix, WordPress host, Vercel, Netlify, etc.

So she may have:

1\. A domain only  
  She owns the web address, but no site is live yet.

2\. A domain \+ Squarespace plan  
  The website can be built and hosted directly in Squarespace.

3\. A domain bought through one company  
  But the site will be hosted somewhere else.

4\. A domain bought through Squarespace  
  But she may still need to choose/pay for a website plan.

Since you’re building in **Claude Code**, you likely do **not** need Squarespace hosting unless she specifically wants to manage the website in Squarespace.

A simple decision tree:

If she wants drag-and-drop editing:  
Use Squarespace.

If you want to build a custom coded site:  
Use Claude Code \+ host on Vercel, Netlify, Cloudflare Pages,  
or similar.

If she already bought the domain:  
You can point that domain to whichever hosting platform you choose.

The key question to ask her is:

Did you only buy the domain name, or did you also buy a Squarespace  
website plan?

And tactically, ask her for a screenshot of where the domain is registered. That will tell you whether it is with Squarespace, GoDaddy, Namecheap, Google Domains/Squarespace Domains, etc.

Domain is registered with Namecheap.  
Thought for a second

Good. That means she likely has **the address only**, unless she also bought hosting separately.

With a Namecheap domain, you can point it anywhere:

Namecheap domain  
       ↓  
DNS settings / nameservers  
       ↓  
Website host

Most likely options:

Option 1 — Build in Squarespace  
Point the Namecheap domain to Squarespace.  
Best if she wants to edit the site herself later with drag-and-drop.

Option 2 — Build with Claude Code  
Host the site on Vercel, Netlify, Cloudflare Pages, or similar.  
Then point the Namecheap domain to that host.

Option 3 — Buy Namecheap hosting  
Possible, but probably not my first choice for a clean modern landing page  
unless she specifically wants WordPress/cPanel hosting.

For your Claude Code path, the clean setup is probably:

1\. Build the site locally / in Claude Code  
2\. Push the code to GitHub  
3\. Deploy to Vercel or Netlify  
4\. Add her custom domain in the hosting platform  
5\. Update DNS records inside Namecheap

Verified docs:

Namecheap has DNS management where you can update records for a domain:  
 [https://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-to-change-dns-for-a-domain/](https://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-to-change-dns-for-a-domain/)

Vercel supports adding a custom domain and then updating DNS records at the registrar:  
 [https://vercel.com/docs/domains/working-with-domains/add-a-domain](https://vercel.com/docs/domains/working-with-domains/add-a-domain)

Netlify has a similar custom domain \+ DNS setup:  
 https://docs.netlify.com/manage/domains/add-a-domain/

My recommendation: **Namecheap domain \+ Vercel hosting** if you’re building with Claude Code. It’s clean, fast, and friendly for a simple landing page.

Would it make sense for her to host using Google Workspace?

I’ll separate the pieces because “Google Workspace” often gets mixed up with domain email, website hosting, and Google Sites.

Thought for 4s

Probably **yes for email**, but **not my first choice for website hosting**.

Google Workspace is mainly for business tools: custom Gmail, Drive, Calendar, Meet, etc. Google describes Workspace as including Gmail with custom business email, Drive storage, Meet, Calendar, Chat, and related tools.

For the website, Workspace connects to **Google Sites**, which is Google’s simple website builder/hosting option. Google Sites can publish a site and connect it to a custom domain.

My recommendation:

Best setup for her:

Namecheap \= domain registrar  
Google Workspace \= professional email  
Vercel / Netlify / Squarespace \= website hosting

For a therapy practice, I’d use Google Workspace for something like:

hello@herpractice.com  
info@herpractice.com  
appointments@herpractice.com

But I’d only use **Google Sites** if she wants the simplest possible website and is okay with a limited design. Google Sites is fine for a basic brochure site, but it is not ideal if you want a polished, custom landing page built with Claude Code.

Better decision tree:

If you are building the site in Claude Code:  
Use Vercel or Netlify for hosting.

If she wants to edit everything herself:  
Use Squarespace.

If she wants ultra-simple and doesn't care much about custom design:  
Use Google Sites through Google Workspace.

If she wants professional email:  
Use Google Workspace regardless of where the website is hosted.

So the clean answer is: **Google Workspace makes sense for her business email and calendar. For hosting the actual website, I’d use Vercel/Netlify if you’re coding it, or Squarespace if she wants no-code editing.**

Can we use Vercel's free tier for this? Assuming they have one  
Thought for 4s

Yes — **Vercel has a free Hobby plan**, and it could work for this **if the site is very simple and low-traffic**.

Verified from Vercel’s current pricing page: the **Hobby** plan is listed as **“Free forever”** and includes repo import, automatic CI/CD, global CDN, DDoS mitigation, HTTPS certificates, and basic traffic/performance insights. It also includes limits like **1M edge requests/month** and **100 GB fast data transfer/month**.

For your sister’s practice landing page, Vercel free tier likely works well if it is:

Static brochure site  
Homepage / About / Services / Contact  
No login  
No database  
No client portal  
No payments  
No HIPAA-sensitive form submissions  
Contact button links to email, phone, SimplePractice,  
Psychology Today, Calendly, or another intake tool

The one thing I would **not** do casually is collect sensitive therapy intake details directly through a custom form on the site unless the form tool/workflow is set up correctly for privacy/compliance.

My practical recommendation:

Namecheap \= domain  
Google Workspace \= professional email  
Vercel Hobby \= free website hosting  
SimplePractice / Psychology Today / secure booking tool \= intake/contact flow

Use Vercel free to launch the site. Upgrade later only if traffic, collaboration, analytics, or commercial/account requirements make it necessary.

