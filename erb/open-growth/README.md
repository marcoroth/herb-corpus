# Open Budget - Personal Budget Management App

A comprehensive Ruby on Rails application to manage budgets, income events, expenses, shopping lists, and home inventory with PostgreSQL as the database. It allows you to create budget periods (monthly, quarterly, custom), plan expenses for each income payment, track expenses by category, manage shopping lists with budget integration, track household inventory, and view dynamic pace calculations to monitor spending.

## Features

### Budget Management
- **Budget Periods**: Create and manage budget periods with start/end dates and total planned amount.
- **Budget Line Items**: Break down a budget period into categories with planned amounts.
- **Categories**: Define categories like Food, Transport, Utilities, etc.
- **Expenses**: Log expenses with date, amount, description, and category. Link expenses to budget periods.
- **Dynamic Pace**: On each budget period's page, view:
  - Amount you should have spent to date (pro rata).
  - Actual amount spent.
  - Remaining budget.

### Income & Expense Planning
- **Income Events**: Track expected and received income payments with dates and amounts.
- **Planned Expenses**: Plan how to allocate each income payment across different expense categories before the money arrives.
- **Expense Templates**: Create recurring expense templates for long-term savings goals (e.g., vacation fund, emergency fund).
- **Previous Balance Tracking**: Automatically track how negative balances from previous income events impact the current event's available budget, providing better visibility into financial flow.

#### Planned Expenses vs. Actual Expenses

The application uses two separate models to distinguish between **planned spending** and **actual spending**:

**Planned Expenses (`PlannedExpense`)**
- Represent your **intended spending** before money is actually spent
- Created when you plan how to allocate an income event
- Have a `status` field (e.g., "pending_to_pay", "saved", "spent", "paid", "transferred")
- Automatically create an `Expense` record when status is set to "spent", "paid", or "transferred"
- Can be manually applied using the "Apply" button to create an expense record

**Actual Expenses (`Expense`)**
- Represent **actual money spent** (real transactions)
- Can be created in two ways:
  1. **From Planned Expenses**: Automatically created when a planned expense status changes to "spent"/"paid"/"transferred", or manually via the "Apply" button
  2. **Direct Expenses**: Created directly and assigned to an income event (for unplanned spending)

**Key Relationships:**
- A `PlannedExpense` can have one `Expense` (via `planned_expense_id`)
- An `Expense` can belong to an `IncomeEvent` directly (for unplanned spending) or through a `PlannedExpense`
- Both planned expenses and direct expenses are counted in the income event's "Total Planned" calculation
- Only actual expenses are counted in "Total Spent"

**Automatic Expense Creation:**
- When you create a planned expense with status "spent", "paid", or "transferred", an expense record is automatically created
- When you update a planned expense status to "spent", "paid", or "transferred", an expense record is automatically created
- The "Apply" button appears for any planned expense that doesn't have an expense record yet, allowing you to manually create it

**Handling Legacy Data:**
- If you have planned expenses with status "spent" but no expense record (from before automatic creation was implemented), the "Apply" button will be visible
- Click "Apply" to manually create the missing expense record

#### Previous Balance Feature

The Previous Balance feature provides visibility into how financial deficits carry forward between income events:

- **Automatic Calculation**: Each income event automatically calculates the previous balance from the immediately preceding income event in the same budget period.
- **Effective Date Ordering**: Events are ordered by `received_date` (if received) or `expected_date` (if pending), ensuring chronological accuracy.
- **Cumulative Carryover**: Negative balances from previous events reduce the effective available budget for the current event, creating a cumulative chain of financial impact.
- **Visual Indicators**: 
  - Red borders and warning icons highlight income events with negative previous balances
  - Clear breakdown shows: `Income Amount - Previous Balance - Planned = Effective Remaining`
  - Color-coded displays (red for negative, green for positive)

**Example**: If your January 15th income had a -$500 deficit and your February 1st income is $2000, the effective remaining budget after planning expenses will be reduced by $500, giving you a true picture of available funds.

### Shopping List & Inventory Management
- **Shopping List**: Track items you need to buy with optional links to planned expenses and categories.
  - Quick add items (name required only, all other fields optional)
  - Mark items as purchased
  - Support for one-time and recurring purchases
  - Filter by status (pending/purchased)
  - Convert shopping items to planned expenses or actual expenses
  - Link shopping items to existing planned expenses
  - Estimated amounts help plan your budget before spending
- **Home Inventory**: Track household items with stock level awareness.
  - Track stock states: in stock, low, or empty
  - Visual indicators (colored circles) for quick status recognition
  - One-click "Add to Shopping List" for low or empty items
  - Categorize items and mark as consumable/non-consumable
  - Filter inventory by stock state
  - Checklist-style interface for easy scanning

**Integration with Budget System:**
- Shopping items can be converted to `PlannedExpense` to plan spending before money arrives
- Shopping items can be converted to `Expense` to record actual spending
- Shopping items can be linked to existing planned expenses
- Estimated amounts from shopping items contribute to budget planning
- Inventory items automatically create shopping items when stock is low or empty

### User Interface
- **Responsive UI**: Browse expenses in table or card grid layouts with Tailwind CSS.
- **Visual Indicators**: Color-coded displays for negative balances, warnings, and status indicators.
- **Filtering & Searching**: Filter expenses by date range, category, and description text.

### Color System Inspiration
- Theme and palette work in this app is inspired by the iOS color reference:
  - https://laochao.github.io/Colors/ios.html
- The palette is applied through semantic design tokens (e.g., `primary`, `accent`, `background`, `sidebar-*`) instead of direct one-to-one color flooding.
- This keeps the UI consistent, accessible, and professional across light and dark modes while preserving iOS-inspired color character.

## Prerequisites

- Ruby (>= 3.0)
- Rails (>= 7.0)
- PostgreSQL

## Setup & Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/budget_tracker.git
   cd budget_tracker
   ```

2. Install gems:

   ```bash
   bundle install
   ```

3. Configure database credentials in `config/database.yml` if necessary.

4. Create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed   # loads default categories
   ```

5. Start the Rails server:

   ```bash
   rails server
   ```

6. Navigate to `http://localhost:3000` in your browser.

### Frontend tools
run and fix linterns for .html.erb files:

```bash
# Run the herb linter
npm run herb:lint

# Run the herb linter with automatic fixes
npm run herb:lint-fix
```
[herb docs here](https://herb-tools.dev/projects/linter)

## Spec-Driven Development

This repository is configured with [GitHub Spec Kit](https://github.com/github/spec-kit) and its Codex integration. Spec Kit keeps feature discovery, design, and implementation tasks versioned alongside the application.

Use the workflow commands in this order for a new feature:

```text
$speckit-specify Describe the feature you want to build
$speckit-clarify              # Resolve open questions, when needed
$speckit-plan                 # Create the implementation plan and design artifacts
$speckit-tasks                # Generate an actionable task list
$speckit-implement            # Execute the task list
```

Additional commands are available for reviewing and maintaining feature artifacts, including `$speckit-analyze`, `$speckit-checklist`, `$speckit-converge`, `$speckit-constitution`, and `$speckit-taskstoissues`.

Feature artifacts are created under `specs/<feature>/` and may include:

- `spec.md` — feature requirements and user scenarios
- `plan.md` — implementation approach and technical design
- `research.md`, `data-model.md`, `contracts/`, and `quickstart.md` — supporting design artifacts
- `tasks.md` — dependency-ordered implementation tasks

The project constitution is stored in `.specify/memory/constitution.md`. The Spec Kit configuration and scripts live in `.specify/`, while the Codex skill instructions live in `.agents/skills/`. Keep these directories under version control so contributors can use the same workflow.

## Usage

* **Dashboard**: Homepage shows quick links to manage budgets, income events, expenses, categories, shopping list, and inventory.
* **Budget Periods**: Create a new budget period, add line items, and view pace checks.
* **Income Events**: 
  - Create income events for expected payments (salary, freelance, etc.)
  - Mark income as received when payment arrives
  - Plan expenses for each income event before receiving the money
  - View previous balance carryover from earlier income events
  - See effective remaining budget that accounts for previous deficits
* **Planned Expenses**: Allocate specific amounts from each income event to different categories and expense templates.
* **Expense Templates**: Create templates for recurring savings goals with progress tracking.
* **Expenses**: Add, edit, and delete expenses. Link expenses to budget periods automatically when using the nested form.
* **Categories**: Define or edit expense categories.
* **Shopping List**: 
  - Add items you need to buy (quick add with name only, or full details)
  - Mark items as purchased when you buy them
  - Set estimated amounts to plan your budget
  - Convert items to planned expenses or actual expenses
  - Filter by status (pending items shown by default)
  - Support for recurring purchases with frequency tracking
* **Home Inventory**: 
  - Track household items and their stock levels
  - Set stock state: in stock, low, or empty
  - One-click add to shopping list when items are low or empty
  - Visual indicators for quick status recognition
  - Filter by stock state to see what needs restocking

## Code Structure

* **Models**:

  * `BudgetPeriod`: has many `BudgetLineItem`, `Expense`, and `IncomeEvent`
  * `IncomeEvent`: belongs to `BudgetPeriod`, has many `PlannedExpense`
    - Tracks expected/received dates and amounts
    - Calculates previous balance from previous income events in the same budget period
    - Provides `effective_remaining_budget` that accounts for previous balance carryover
  * `PlannedExpense`: belongs to `IncomeEvent`, `Category`, and optionally `ExpenseTemplate`
    - Links planned expenses to income events
    - Has one `Expense` (created automatically when status is "spent"/"paid"/"transferred")
    - Can be manually applied to create actual expenses via `apply!` method
    - Automatically creates expense records via callbacks when status changes to spent/paid/transferred
  * `ExpenseTemplate`: has many `PlannedExpense`
    - Tracks progress toward savings goals
    - Supports different frequencies (one-time, monthly, etc.)
  * `BudgetLineItem`: belongs to `BudgetPeriod` and `Category`
  * `Category`: has many `Expense`, `BudgetLineItem`, `PlannedExpense`, `ShoppingItem`, and `InventoryItem`
  * `Expense`: belongs to `Category`, `BudgetPeriod`, and optionally to `IncomeEvent` and `PlannedExpense`
    - Can be created from a planned expense (has `planned_expense_id`)
    - Can be created directly and assigned to an income event (for unplanned spending)
    - Has one `ShoppingItem` (optional, for items converted from shopping list)
    - Both types are counted in income event calculations
  * `ShoppingItem`: belongs to `Account`, `Category` (optional), `PlannedExpense` (optional), and `Expense` (optional)
    - Tracks items to buy with status (pending/purchased) and type (one_time/recurring)
    - Can be converted to `PlannedExpense` or `Expense`
    - Can be linked to existing `PlannedExpense`
    - Supports estimated amounts for budget planning
  * `InventoryItem`: belongs to `Account` and `Category` (optional)
    - Tracks household inventory with stock states (in_stock/low/empty)
    - Can create `ShoppingItem` when stock is low or empty
    - Supports consumable/non-consumable classification
  * `PlannedExpense`: belongs to `ShoppingItem` (optional) - can be linked to shopping items

* **Controllers**:

  * `DashboardController#index` — main landing page.
  * `BudgetPeriodsController` — CRUD for budgets.
  * `IncomeEventsController` — CRUD for income events with receive/apply actions.
  * `PlannedExpensesController` — manage planned expenses within income events.
  * `ExpenseTemplatesController` — CRUD for expense templates.
  * `BudgetLineItemsController` — manage line items inside a budget.
  * `ExpensesController` — CRUD for expenses (nested under budgets for new/create).
  * `CategoriesController` — CRUD for categories.
  * `ShoppingItemsController` — CRUD for shopping items with custom actions (mark_as_purchased, convert_to_planned_expense, convert_to_expense, link_to_planned_expense).
  * `InventoryItemsController` — CRUD for inventory items with add_to_shopping_list action.

* **Views**: Implemented with Tailwind CSS in ERB templates. Key pages:

  * Dashboard (`app/views/dashboard/index.html.erb`)
  * Income events index with previous balance indicators (`app/views/income_events/index.html.erb`)
  * Income event detail with effective remaining budget (`app/views/income_events/show.html.erb`)
  * Budget period overview with pace check (`app/views/budget_periods/show.html.erb`)
  * Expenses index as table or card grid (`app/views/expenses/index.html.erb`)
  * Shopping list index with status filtering (`app/views/shopping_items/index.html.erb`)
  * Inventory checklist-style view (`app/views/inventory_items/index.html.erb`)

* **Helpers**:

  * `BudgetPeriodsHelper` for pace calculations (`should_have_spent`, `remaining_budget`).

## Testing

The application uses Minitest for testing. Comprehensive regression tests ensure the previous balance calculation works correctly across various edge cases.

Run all tests:
```bash
rails test
```

Run specific test files:
```bash
rails test test/models/income_event_test.rb
```

### Test Coverage

The `IncomeEvent` model includes comprehensive tests for:
- Previous balance calculation with events on the same date
- Handling of received vs expected dates for ordering
- Budget period isolation
- Cumulative balance carryover chains
- Year boundary handling
- Negative balance impact calculations

See `test/models/income_event_test.rb` for full test coverage.

## Future Improvements

### Additional Enhancements

* Recurring budgets (auto-generate new periods).
* CSV import/export of expenses and budgets.
* Email or in-app notifications on over/under-spend.
* Charts and dashboards using Chartkick or Recharts.
* Pagination with Kaminari or Pagy.
* User authentication/authorization with Rails Authentication and Pundit.
* Mobile app support (React Native or PWA).
* Multi-currency support.
* Budget templates for common scenarios (student, family, freelancer).

## Contributing

1. Fork the repo.
2. Create a feature branch `git checkout -b feature/my-feature`.
3. Commit your changes `git commit -m "Add my feature"`.
4. Push to the branch `git push origin feature/my-feature`.
5. Open a pull request.

### Commit messages

Use conventional commits, and choose a scope that names the code surface you changed instead of the exact file path.

In this repo, the most useful scopes are usually:

```bash
feat(Financial::EntriesController): ...
fix(Financial::CategoriesController): ...
feat(PlannedExpenses::ExecuteService#call): ...
feat(PlannedExpenses::ExecuteService): ...
fix(Career::JobApplicationsController#show): ...
```

Use controller or service class names for backend changes, add `#method` when the change is specific to a single method, and use component or view-area scopes for UI work.

For views, prefer the page, route, partial, or component name over the raw `.html.erb` path:

```bash
feat(budget_periods#show): render income allocation summary
feat(expenses#index): add category filter
fix(expenses#new): preserve selected category after validation
style(layout): adjust mobile navigation padding
```

For partials and reusable view pieces, scope by the partial or component name:

```bash
feat(planned_expenses/card): show execution status
refactor(income_events/form): extract routing fields
fix(expenses/form): keep validation errors visible
style(Ui::CardComponent): adjust spacing
```

Use `feat` when the UI exposes new information or behavior, `fix` when it corrects a bug, `style` for visual-only changes, `refactor` for internal cleanup, `test` for test-only updates, and `chore` for maintenance work. If a file path is the clearest scope, use it sparingly.

## License

MIT © Diego Vidal Lopez
