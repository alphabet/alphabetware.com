# Introvert-Friendly Action Plan
## Get Your Next Role Without Networking Hell

**The Strategy:** Let your work do the talking. Build an online presence so compelling that companies come to you.

---

## THE CORE PRINCIPLE

**Instead of:** 50 networking calls, conference talks, constant LinkedIn engagement
**Do this:** Write excellent content, build impressive demos, send strategic emails

**Goal:** Inbound interest from companies who've already seen your work

---

## MONTH 1: BUILD THE FOUNDATION (Zero Calls Required)

### Week 1: Portfolio Setup
- [ ] **Update your website homepage**
  - Add banner: "Currently exploring senior technical roles in privacy tech & computer vision"
  - Add section: "I prefer async communication - explore my work below or email me"

- [ ] **Create /projects page**
  - **AVU Wallet:** "Anonymous User Verification System"
    - Problem: Companies need to verify users without collecting PII
    - Solution: WebAuthn + blockchain + zero-knowledge proofs
    - Tech: JavaScript, ethers.js, crypto API, DID spec
    - Link to live demo + workflow diagram
    - "Available for advisory/consulting on similar systems"

  - **Wheel Swap (Computer Vision):**
    - Problem: Detecting and swapping wheels on cars from different angles
    - Challenge: Perspective-aware segmentation
    - Tech: Computer vision, ML models
    - Link to live demo

  - **Rails 7.2 + Ruby 4.0.1 Migration:**
    - Migrated production app from Rails 6.1/Ruby 2.7 to Rails 7.2/Ruby 4.0
    - Zero downtime, fixed Zeitwerk issues, Puma 7 upgrade
    - Lessons learned, war stories

  - **Secure Files Middleware:**
    - Sessionless authentication with time-based HMAC tokens
    - Rack middleware for protecting static files
    - "Available as open source gem (coming soon)"

- [ ] **LinkedIn profile update**
  - Headline: "Staff Architect | Privacy Tech & Computer Vision | Available for Senior Technical Roles"
  - About section: Lead with impact, end with "I prefer email - reach out at [email]"
  - Turn on "Open to Work" (recruiters only)
  - Featured section: Link to AVU demo, projects page, best code samples

### Week 2: First Blog Post
**Title:** "Building Privacy-First User Verification: A Technical Deep Dive"

**Outline:**
1. The Problem: Trust without surveillance
2. Architecture: WebAuthn + Blockchain + ZKP
3. Implementation: Code walkthrough
4. Challenges: Browser compatibility, UX, key management
5. Use Cases: Healthcare, UGC platforms, age verification
6. What's Next: Hyperledger integration, third-party access controls

**Publishing:**
- Publish on your website first (SEO benefit)
- Cross-post to Dev.to (tag: privacy, blockchain, webauthn)
- Cross-post to Medium
- Submit to Hacker News
- Share on LinkedIn (1 post, let it work for you)

**Expected outcome:** 500-1000 views, some email inquiries

### Week 3: Open Source AVU Demo
- [ ] Clean up code, add comprehensive README
- [ ] Document architecture (use your existing diagrams)
- [ ] Add LICENSE (MIT)
- [ ] Create GitHub repo: `avu-wallet-demo`
- [ ] Tags: privacy, blockchain, webauthn, identity, zero-knowledge
- [ ] Submit to Awesome lists:
  - [Awesome Privacy](https://github.com/pluja/awesome-privacy)
  - [Awesome Blockchain](https://github.com/yjjnls/awesome-blockchain)
  - [Awesome WebAuthn](https://github.com/herrjemand/awesome-webauthn)

**Expected outcome:** 50-100 GitHub stars, appears in searches

### Week 4: Research & First Outreach
- [ ] **Research 10 target companies**
  - Read their engineering blogs
  - Find technical pain points they've written about
  - Identify decision makers (CTO, VP Eng, Head of Architecture)
  - Find email addresses (Hunter.io, LinkedIn, company site)

- [ ] **Send 5 personalized emails** (template below)
  - NO call asks
  - Link to relevant demo
  - Provide all context upfront

**Expected outcome:** 1-2 responses, maybe 1 intro call (save for best opportunity)

---

## EMAIL TEMPLATE (Introvert Edition)

```
Subject: [Their blog post title] - built something similar

Hi [Name],

Read your post on [specific topic]. The section about [specific challenge] resonated - I recently built a similar system at [non-profit org].

Here's what I built: [link to AVU demo]

It addresses [their pain point] using [your approach]. I also wrote up the technical details here: [link to blog post]

After 10+ years leading architecture at [org], I'm exploring senior technical roles where I can work on [their domain] problems. Happy to share more via email if there's a potential fit.

Technical portfolio: [your website]
GitHub: [your profile]

Best,
Gui

P.S. - Also built [other relevant project] if [other pain point] is relevant: [link]
```

**Why this works:**
- Respects their time (no call ask)
- Shows, doesn't tell (links to actual work)
- Gives them everything they need to evaluate you
- Low pressure

---

## MONTH 2: CONTENT & PASSIVE OUTREACH

### Blog Post 2: "Self-Sovereign Identity: Beyond the Buzzword"
- W3C DID spec implementation
- Real use cases (not hype)
- Code examples from your demo

### Blog Post 3: "Migrating to Rails 7.2 & Ruby 4.0: Production War Stories"
- Zeitwerk gotchas
- Puma 7 configuration
- OpenSSL 3 compatibility
- Lessons learned

### Email Outreach
- Send 10 more personalized emails to companies
- Follow up (once, gently) on first batch after 2 weeks

### Stack Overflow
- Answer 5 questions in: `rails`, `zeitwerk`, `privacy`, `webauthn`
- Link to your blog posts when relevant
- Builds reputation, shows expertise

---

## MONTH 3: ACCELERATION

### Blog Post 4: "Computer Vision in Production: The Wheel Swap Project"
- Detection → Segmentation → Transformation
- Handling perspective challenges
- Model selection, deployment

### Open Source Release
- Extract your Rack middleware as `secure-files-middleware` gem
- Publish to RubyGems
- Announce on Reddit r/rails, Ruby Weekly

### Pre-Recorded Demo Video
- 5-minute walkthrough of AVU demo
- Voiceover explaining architecture
- Upload to YouTube, embed on projects page
- No live presenting required!

### Continue Email Outreach
- 10 more companies
- By now you have more content to link to

---

## TARGET COMPANIES (Introvert-Friendly)

**These companies value:**
- Deep technical work over networking
- Async communication
- Remote-first culture
- Engineers who ship

**Privacy/Identity Tech:**
- [ ] **Privado** - Privacy engineering platform
- [ ] **Skyflow** - Data privacy vault
- [ ] **Transcend** - Privacy infrastructure
- [ ] **Turnstile/Cloudflare** - Bot detection without captcha
- [ ] **Auth0** - Identity platform
- [ ] **Persona** - Identity verification

**Computer Vision/AI:**
- [ ] **Scale AI** - ML infrastructure
- [ ] **Roboflow** - Computer vision tools
- [ ] **Labelbox** - ML data platform
- [ ] **Runway** - Generative AI (you have video gen experience!)

**Remote-First, Async Cultures:**
- [ ] **GitLab** - Famous async culture
- [ ] **Automattic** (WordPress) - Async-first
- [ ] **Doist** (Todoist) - Remote, minimal meetings
- [ ] **Basecamp** - Minimal meeting culture

---

## CONVERSATION BUDGET (1-2/month)

**Save your calls for:**
1. Final round interviews only
2. Exceptional opportunities (dream companies)
3. Offers/negotiations

**Decline/defer everything else:**
- "I'm happy to share more via email first"
- "Let me send you a detailed write-up"
- "Can we start async and schedule a call if needed?"

**Most "informational interviews" can be emails:**
- They ask questions → you send thoughtful written responses
- More efficient for both parties
- You give better answers when you can think/edit

---

## METRICS TO TRACK (Async Success)

### Month 1
- LinkedIn profile views: 500+
- Blog post views: 500+
- GitHub stars: 50+
- Emails sent: 5
- Email responses: 1-2

### Month 2
- Blog post views: 1,000+
- GitHub stars: 100+
- Emails sent: 10
- Company conversations (via email): 5+
- Stack Overflow reputation: +100

### Month 3
- Blog post views: 2,000+
- GitHub stars: 200+
- Emails sent: 10
- Active email threads: 5-10
- Interview processes: 2-3
- Actual calls taken: 1-2 (final rounds)

---

## RED FLAGS TO AVOID

**Companies that won't work for introverts:**
- "We're a family" (forced social events)
- "High-energy collaborative environment" (open office, constant interruptions)
- "Daily standups" + "Weekly all-hands" + "Team bonding" (meeting hell)
- "In-office required" (harder to control social interactions)
- Sales-oriented cultures (finance, some startups)

**Green flags to seek:**
- "Remote-first"
- "Async communication preferred"
- "Documentation culture"
- "Deep work time"
- "Written RFCs"
- Companies that hire globally (must be async)

---

## IF YOU GET OVERWHELMED

**Scale back to minimum viable job search:**

1. **One blog post per month** (3 total)
2. **Open source your best work** (AVU demo)
3. **Send 3 perfect emails per month** to dream companies
4. **Update LinkedIn once** and turn on "Open to Work"
5. **Take 1 call only if it's a final interview**

**That's it.** Quality over quantity.

**The goal:** Build such a strong online presence that companies find you.

---

## YOUR UNFAIR ADVANTAGES

1. **Your demos are better than most people's resumes**
   - AVU wallet is more impressive than "worked on identity systems"
   - Wheel Swap shows real CV chops
   - These took deep work - introvert superpower

2. **Your writing will be more thoughtful**
   - Introverts write better than they small-talk
   - Technical blog posts show clearer thinking than networking events

3. **Senior roles care about what you've built**
   - Not how many people you know
   - Not how well you network
   - Can you architect complex systems? (Yes - you have proof)

4. **Async-first is the future**
   - Best companies are going remote
   - Remote requires async skills
   - You're already great at this

---

## FINAL THOUGHT

**The best outcome:** A company reaches out to you because they read your blog post about privacy architecture, tried your AVU demo, and realized you're exactly who they need.

**This is 100% achievable** without a single networking event.

**Start this week:**
1. Update LinkedIn (30 min)
2. Create projects page (2 hours)
3. Start writing first blog post (this weekend)

**The rest will follow.**
