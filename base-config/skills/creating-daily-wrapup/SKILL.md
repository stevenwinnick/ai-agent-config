---
name: creating-daily-wrapup
description: Create a daily wrap-up for Steven by checking calendar, email, Circleback, and Linear for open tasks and suggesting prioritized follow-ups. Use for an end-of-day review or a cross-source review of outstanding commitments; this skill recommends actions without carrying them out.
---

# Creating Daily Wrapup

Give Steven an evidence-backed view of his open tasks and useful next actions across calendar, email, Circleback, and Linear

## Scope and Boundaries

This is a read-only review. Read and search sources, then present findings and suggested follow-ups in chat. Do not complete tasks, create or update issues, change statuses or assignees, send messages, save email drafts, mark messages read, alter calendar events, or create reminders or automations. A suggested action is not authorization to execute it. If Steven later asks to act on a recommendation, handle that as a separate authorized request

Use Steven's timezone and the requested date or period, defaulting to today. The day's activity is the starting point, not a cutoff for unfinished work: include older unresolved commitments and upcoming deadlines that still need attention. Resolve Steven's identity in each source from available account and participant information; a connected robot account is not necessarily Steven's personal identity

## Check All Four Sources

Attempt each source with the available connected tools. If a source is unavailable, continue with the others and disclose the gap rather than silently omitting it

- **Calendar:** Review the day's meetings and relevant recent or upcoming events for promised follow-ups, preparation, deadlines, and linked materials. An event's attendance list or end time alone does not establish a task or prove it was completed
- **Email:** Inspect relevant received and sent threads for requests to Steven, his commitments, unanswered questions, and work awaiting someone else's response. Include read or archived messages when relevant; unread status is not a reliable task list. Read later replies before labeling an item unresolved
- **Circleback:** Read relevant meeting summaries, action items, and transcripts where clarification is needed. Identify commitments assigned to Steven, open decisions, and follow-ups from earlier meetings. Verify ambiguous owners or wording against the underlying discussion when available
- **Linear:** Retrieve Steven's non-completed, non-canceled assigned issues, including older and overdue work, and inspect relevant descriptions, comments, dependencies, due dates, and status changes. Review mentions or requests for his input when relevant, but do not treat every issue he created, follows, or is mentioned in as his task. Use the workspace's actual status meanings

Follow pagination when needed to cover the relevant results. Expand searches into older history when an unresolved commitment or dependency points there. State the date ranges searched and any result limits or incomplete coverage; do not claim an exhaustive inventory when the accessible evidence does not support one

## Reconcile Open Work

Combine references to the same commitment across sources into one item, retaining useful source links. Check later messages, meeting decisions, and issue updates for evidence that it was completed, canceled, reassigned, or superseded before recommending a follow-up

Separate work Steven owns from work he is waiting on and items with uncertain ownership or status. Do not assign him a task merely because he attended a meeting or received an email. Label inferred commitments and conflicting evidence rather than presenting them as confirmed obligations. If a task appears completed but Linear remains open, suggest confirming or reconciling its status instead of recommending the work again

Prioritize using explicit deadlines, overdue commitments, dependencies, and impact. Distinguish recorded due dates from suggested timing; do not invent urgency, deadlines, or promises. A waiting item does not automatically need another nudge if the agreed response date has not passed

## Deliver the Wrap-Up

Lead with the most useful next actions, followed by the remaining open work and any uncertainty. Use concise sections such as:

- **Priority follow-ups:** Items needing attention first, with a concrete suggested next step and why it matters now
- **Other open tasks:** Remaining confirmed responsibilities, grouped by project or person when useful
- **Waiting on others:** Who owes what, any agreed timing, and whether a follow-up is warranted
- **Needs clarification:** Uncertain ownership, conflicting status, or missing evidence that prevents a reliable recommendation
- **Coverage:** Sources checked, date ranges or scope, and unavailable sources or incomplete results

For each task, include enough context to act: the commitment, current status or blocker, known owner and deadline where relevant, a specific suggested follow-up, and links to supporting records. Suggest whom to contact and what to ask or resolve, rather than saying only "follow up." Avoid repeating the same task across sections

Use actual source URLs supplied by tools; do not invent links. Keep recommendations clearly prospective, and never imply they have been carried out. Omit empty task sections. If no open tasks are found, say so within the scope checked, retaining any coverage limitations
