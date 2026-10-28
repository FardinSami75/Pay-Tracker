# Pay Tracker

Sami's personal pay tracker for **University AV/IT**, **Winners**, **Stampede** and **Mercor**. It works out breaks, overtime, stat pay, paydays and earnings automatically, shows pie charts by job, and imports and exports Excel files.

**Live site:** https://fardinsami75.github.io/Pay-Tracker/

It runs on two free services:

- **GitHub Pages** hosts the website (this repository).
- **Supabase** stores the data and handles sign-in, so the same data shows on every device.

Only the code is in this repository. No shift or pay data is stored here.

---

## Features

### Shifts (University AV/IT, Winners, Stampede)
- Log a shift with the date, job, and in and out times. Break, paid hours, overtime, stat pay and earnings are worked out automatically.
- Shifts that run past midnight are handled.
- Logging the same job on the same date again **replaces** that shift. Use this when a shift ran longer than planned.
- Edit or delete any shift from the monthly list.
- Shifts on future dates are marked **Scheduled**.

### Mercor (contract work, paid in US$)
- Log work by **date, project or task, hours, and hourly rate in US$**. Hours can be typed as `2.5`, `2:30` or `2h 30m`.
- Each project remembers its last rate, so picking a project fills in the rate.
- **Bonuses:** none, a flat amount (US$), or an extra amount per hour (US$/h), with a note like "Weekend bonus". Bonuses are shown separately from base pay.
- **US$ → CA$:** the exchange rate for that day is looked up automatically (ECB rate via frankfurter.dev, with the Bank of Canada as a backup) and saved with each entry. It can be changed by hand to match the rate Mercor's payout actually used.
- The Mercor section shows US$ earned, the CA$ equivalent, hours, average rate, a breakdown by project, and the month's entries.
- Mercor is counted in CA$ in the overall totals, the pie charts and the job table.
- Mercor is contract work, so no tax is taken off. It's shown separately for that reason.

### Paydays
- **Next pay** cards show the amount, the payday, how many days away it is, and the work period for each job. The soonest one is highlighted.
- A table lists every payday in the month you're viewing, with a status: Paid, Upcoming, or Estimate (the period still has future shifts, or the Mercor CA$ amount is estimated).
- All amounts are **gross**, before tax and deductions.

### Charts and summaries
- A summary strip for the month: earnings, paid hours, shifts and Mercor entries, and days off.
- Pie charts of paid hours and earnings by job (this month or all time), plus a table by job.

### Excel
- **↓ Download Excel** gives you an Overview sheet, a Paydays sheet, a Mercor sheet, and one sheet per month (with every day listed) up to next month.
- **↑ Upload Excel** adds shifts and Mercor entries from a filled-in file. A preview shows what will be added or changed before anything is saved.
  - **Shifts:** fill in Job, In and Out on the day's row. Job can be `AV/IT`, `University`, `Winners` or `Stampede`. Times can be `17:30`, `5:30 PM` or `5pm`.
  - **Mercor:** add rows at the bottom of the Mercor sheet with Date (YYYY-MM-DD), Project, Hours and Rate (USD). Bonus, bonus note and exchange rate are optional. A missing exchange rate is looked up.
  - An existing shift for the same job and date gets updated. Deleting a row in Excel does **not** delete anything on the site.

### Look
- **Theme button** (◐ Auto / ☀ Light / ☾ Dark) at the top. Auto follows your phone's or computer's setting. Your choice is remembered on each device.

### Backups and account
- **Download backup / Import backup** (under *Pay rates & break rules*) saves or restores everything as a `.json` file.
- Email and password sign-in. Each account can only see its own data, and new sign-ups are turned off in Supabase.

---

## Pay rules

### Rates (CA$/hour)
| Job | Rate | Since |
|---|---|---|
| University AV/IT | $22.50 | May 2026 |
| University AV/IT | $23.50 | June 2026 |
| Winners | $16.14 | May 2026 |
| Winners | $16.87 | June 2026 |
| Stampede | $22.00 | May 2026 |
| Mercor | Varies by project, in US$ | Oct 2026 |

New raises are added on the site under **Pay rates & break rules**. Each raise starts from its own date, so past months stay correct.

### Unpaid breaks
| Job | 5 h or less | Over 5 h | Other |
|---|---|---|---|
| University AV/IT | None | 30 min | 60 min at 8 h or more |
| Winners | None | 30 min up to 6.5 h | 45 min over 6.5 h |
| Stampede | None | 30 min | — |
| Mercor | — | — | No break rules; hours are entered as worked |

### Overtime and stat holidays
- Worked hours past 8 in a shift pay **1.5×** (all shift jobs).
- **Winners only:** every hour on an Alberta general holiday pays **1.5×**. The holidays are New Year's Day, Family Day, Good Friday, Victoria Day, Canada Day, Labour Day, Thanksgiving, Remembrance Day and Christmas Day.

### Pay schedules
| Job | Work period | Payday |
|---|---|---|
| University AV/IT | 1st–15th | 25th of the same month |
| University AV/IT | 16th–end of month | 10th of the next month |
| Winners | 2 weeks, Sunday → Saturday (e.g. Sep 27 – Oct 10) | Friday, 6 days after the period ends (e.g. Oct 16) |
| Mercor | 1 week, Friday → Friday (cutoff Fri 10:30 AM PT) | The following Wednesday |
| Stampede | Not set up yet | — |

- University paydays that fall on a Saturday or Sunday are paid the **Friday before** (for example, the Oct 25, 2026 pay arrived Fri Oct 23).
- Mercor's very first payout through Stripe has a one-time 7-day hold.

---

## Setup (already done)

1. **Supabase:** a project in Canada (Central). Run `setup.sql` in **SQL Editor**. Put the Project URL and publishable key in `config.js`.
2. **GitHub Pages:** this repository, deployed from the `main` branch, root folder.
3. **Supabase → Authentication → URL Configuration:** Site URL set to the live site address.
4. **Supabase → Authentication → Sign In / Providers:** *Allow new users to sign up* turned **off** after the account was created.

### Database tables
| Table | What it holds |
|---|---|
| `shifts` | date, job, time in, time out |
| `rates` | job, start date, hourly rate (CA$) |
| `mercor_tasks` | date, project, hours, rate (US$), bonus (US$), bonus note, US$→CA$ rate |

All tables use row-level security, so each signed-in user only sees their own rows. The SQL for every table is in `setup.sql`. It's safe to run again, because it skips anything that already exists.

### Files
| File | Purpose |
|---|---|
| `index.html` | The whole app: page, styles and logic |
| `config.js` | Supabase project URL and publishable key (safe to be public) |
| `setup.sql` | Database tables and security rules |
| `README.md` | This file |

### Good to know
- **Free Supabase projects pause after about a week with no use.** If the site can't load your data, sign in at supabase.com and click **Restore project**. The data is kept.
- **Updating the site:** upload a new `index.html` to this repository. It goes live in 1–2 minutes. The data in Supabase isn't touched.

---

## Change log

| Date | Change |
|---|---|
| 2026-10-27 | **Theme button:** switch between Auto (follows the device), Light and Dark. Remembered per device. |
| 2026-10-27 | **Mercor added:** logging by project with US$ rates, flat or per-hour bonuses, automatic US$→CA$ conversion (editable per entry), a US$ and CA$ summary, a by-project breakdown, weekly Wednesday paydays, Mercor in charts and totals, and a Mercor sheet in the Excel download and upload. New `mercor_tasks` table. This README became the project guide. |
| 2026-10-24 | **Excel upload:** add or update many shifts at once from a filled-in Excel file, with a preview. The Excel download now includes every month up to next month. |
| 2026-10-24 | **Paydays:** next-pay cards, a monthly payday table, and a Paydays sheet in Excel. University weekend paydays move to the Friday before. |
| 2026-10-19 | **Moved to GitHub Pages + Supabase** with email sign-in, backup and restore, and the Excel download. All shifts from May–Oct 2026 imported. |
| 2026-10-19 | **First version:** shift logging with automatic break, overtime and stat pay rules, pie charts by job, and monthly summaries. |
