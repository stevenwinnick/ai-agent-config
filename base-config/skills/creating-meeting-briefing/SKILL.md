---
name: creating-meeting-briefing
description: Create a briefing for Steven on an upcoming calendar meeting, combining likely objectives, shared interaction history, researched participant background, and an actionable agenda. Use when Steven asks for meeting preparation or a pre-meeting briefing.
---

# Creating Meeting Briefing

Prepare Steven for an upcoming meeting using his calendar, relevant relationship history, and web research on the people he will meet

## Identify the Meeting

Find the requested upcoming event in the connected calendar, using Steven's timezone for relative dates. Read its title, time, attendees, description, and relevant linked materials. If several events plausibly match and context does not resolve them, ask which meeting he means. If calendar access is unavailable, ask for the event details and disclose that limitation

Use attendee email addresses, affiliations, and the invitation context to distinguish people with similar names. For group meetings, cover the participants relevant to the likely objectives and clearly attribute each person's background and interactions

## Research and Synthesize

### Likely Objectives

Infer the intended outcomes from the invitation, scheduling exchanges, prior conversations, and outstanding decisions or commitments. Prefer explicit goals when available; make inferred goals recognizable as inferences. Objectives should describe what Steven wants to accomplish, rather than simply naming discussion topics

### Mutual Context

Search relevant available sources, including email, Notion, Circleback meeting notes or transcripts, and other connected tools, for Steven's interactions with the person and the history leading to this meeting

Capture how they connected, substantive prior discussions, shared interests or projects, decisions, promises, open questions, and follow-up items. Include older interactions when they explain the relationship or an unresolved commitment; prioritize what will matter in this meeting. Distinguish direct interactions from secondhand references, and do not treat one participant's statements as agreed facts

Group related context under descriptive headers. Use one or several sections as useful; brief sections can be a short paragraph without bullets

### Individual Context

Include relevant background about the person beyond their interactions with Steven. Use connected sources and always include a web search for the person unless Steven explicitly asks to omit web research. Confirm identity before attributing results, and prefer primary sources such as institutional profiles, personal or lab sites, publications, and company pages

Explain their current role, relevant experience, interests, and recent work in terms that help Steven understand their perspective and prepare for the meeting. Verify time-sensitive details and avoid filling the briefing with unrelated biography

For scientists, assume Steven is unfamiliar with their work even if he has referenced it in earlier interactions. Explain the relevant research in plain language: the problem they study, their approach, specific contributions or findings, why those matter, and how they connect to the meeting. Define necessary terminology and distinguish established findings from hypotheses or preliminary results. Read relevant primary research when needed rather than relying on paper titles or reputation alone

### Meeting Notes

Create an agenda that helps achieve the likely objectives. Under concrete topic labels, include useful questions, points to raise, decisions to seek, and next steps to agree on. Build on the research and outstanding commitments; avoid generic conversation prompts. These are prospective notes for the upcoming meeting, so do not invent answers, decisions, or completed discussion

## Evidence and Gaps

Place concise source links alongside substantive context and research claims so Steven can inspect the underlying email, note, profile, or paper. Use actual source URLs returned by tools; do not invent links. Distinguish sourced facts from inference and flag conflicts or meaningful uncertainty

If a source is unavailable or searches find no relevant history, briefly state the limitation in the affected section. A failed or empty search does not establish that no prior interaction occurred. Continue with available evidence without fabricating context

## Output

Deliver the briefing in the following Markdown structure. Use `Likely Objective` for one objective and `Likely Objectives` for more than one. Replace the template labels with descriptive context headers and agenda topics, repeating them as needed. Preserve the top-level sections and their order

```markdown
## Pre-Meeting Notes

### Likely Objectives

1. <Objective>

### Mutual Context

<Context header>

- <Relevant shared context, with source link>

### Individual Context

<Context header>

- <Relevant background or research explanation, with source link>

## Meeting Notes

<Agenda topic>

- <Point to raise, question to ask, or decision to seek>
```

Keep the briefing easy to scan while providing enough explanation to make unfamiliar scientific work understandable. Identify the meeting and its time briefly above the template if needed to orient Steven. Return it in chat unless he requests another destination; creating a briefing does not itself authorize changing calendar events, sending messages, or publishing notes elsewhere
