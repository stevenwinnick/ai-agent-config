---
name: creating-daily-wrapup
description: Review Steven's day and outstanding commitments across calendar, email, Circleback, Linear, and Notion. Prioritize next actions and save needed follow-up email drafts in Superhuman, without sending them.
---

# Creating Daily Wrapup

Review the requested day in Steven's timezone, defaulting to today, plus older unresolved commitments and upcoming deadlines. Honor his corrections and prior automation memory. Resolve his identity in each source; a connected robot account may not be Steven

## Boundaries

Invoking this skill authorizes saving email drafts in Superhuman without further confirmation. Never send or schedule messages. Leave other external records unchanged: no task/status updates, read-state changes, calendar edits, or reminders

## Review the Sources

Attempt all five sources. Follow pagination needed for coverage and report unavailable sources or incomplete searches

- **Calendar:** Review the day's calls and relevant upcoming events. Distinguish calls that happened from canceled, no-show, and future events; attendance alone establishes neither ownership nor completion
- **Email:** Read relevant incoming and sent threads, including read and archived mail. Check later replies before deciding an email is needed
- **Circleback:** Read meeting notes and action items; consult transcripts to clarify ownership, promises, or offers of help
- **Linear:** Review Steven's open assigned issues, deadlines, blockers, and relevant comments. Check completed/canceled issues for evidence that work is already handled
- **Notion:** Review relevant tasks, project pages, notes, and checklists using their actual status meanings. Authorship or a mention alone does not establish ownership

Combine records for the same commitment. Check later correspondence, discussions, deliverables, and tracker updates before recommending work or drafting. Exclude completed, canceled, reassigned, or superseded work. For partial completion, identify only what remains. Distinguish Steven's responsibilities from waiting on others; do not chase before agreed timing. Put uncertain ownership or completion under Needs clarification

## Draft Needed Emails

Consider every meeting Steven had that day, including in-person meetings, and older loose threads needing an email. Draft a useful follow-up when none has been sent; a specific thank-you or recap can suffice without an explicit action item. Skip inappropriate or redundant email, such as routine internal syncs handled elsewhere

**Organizing-lead rule:** For meetings with multiple Cascadium participants, draft only if Steven led organizing the meeting. Verify this from scheduling correspondence and meeting context, not attendance or an assigned action. The calendar organizer is evidence, not proof. If someone else led organizing, skip; if unclear, flag it without drafting. Apply the same rule to revisions and meeting-derived loose threads

For each eligible email:

1. **Verify context.** Establish the purpose, current direction, and remaining next step from the sources. Check for later follow-ups, including work handled by teammates or other channels. A pre-call scheduling message does not satisfy a post-call follow-up
2. **Choose account and recipients.** List Superhuman accounts and use the relevant acting account. Verify addresses from correspondence or participant records. Prefer the relevant existing thread; otherwise compose a new email. Choose recipients and CCs deliberately. Flag unresolved addresses or ownership rather than guessing
3. **Check existing drafts.** List and read drafts, matching account, recipients, thread, and purpose. Reuse suitable drafts. Update in place with draft/thread IDs only when needed, preserving Steven's edits; leave uncertain edits for review. Recheck sent mail and drafts before saving, and inspect drafts before retrying an ambiguous failure
4. **Write and save.** Use Superhuman's create_or_update_draft with instructions grounded in the evidence. Write in Steven's voice: concise, specific, warm, direct, no em dashes, emojis, or flattery. Reference offers of guidance or introductions explicitly. Do not invent capabilities, decisions, availability, deadlines, commitments, or attachments. Flag missing facts that prevent an accurate draft
5. **Verify.** Inspect returned recipients, subject, and body; correct unsupported additions in the same draft. Confirm a saved draft ID and retain the account, thread ID, and review URL. Never send, schedule sending, or discard drafts

Use sent and archived mail for completion checks even if a generic drafting workflow suggests inbox-only searches. The scope and drafting authorization are already established; do not add another approval step. If Superhuman is unavailable, report unsaved drafts and provide useful proposed text in chat

## Deliver the Wrap-Up

Lead with priority actions, then drafts ready for review, other open work, waiting items, and uncertainties. Omit empty sections. For each item, give the concrete next step, owner, recorded deadline or blocker, and supporting links. Distinguish suggested timing from actual deadlines

List drafts by recipient, subject, purpose, and returned review link, including any sharing notice. Distinguish new, revised, existing, and unsaved drafts; saving is not sending or completing the follow-up. Account for eligible calls and loose threads as drafted, already handled, excluded, or blocked, grouping routine exclusions

Briefly state sources, date ranges, and coverage gaps. Do not claim an exhaustive review when coverage is incomplete. For automated runs, update memory with corrections, draft/account/thread IDs, outcomes, and the run time so future runs can verify current state without duplicating work
