# Rolfs-TableSearch

This package contains the functionality to search database tables of zammad via REST.

Be aware that this package is still in early development and will be reworked heavily in the next releases.

To use the endpoints you will need a admin with the permissions `admin.table_search`.

## Todo / Ideas

- [ ] Complex query syntax (`name IN (1,2,3) AND id: 1 AND title: "test"`)
- [ ] Add endpoints to check database table definitions
- [ ] Tests

## How to install the package

1. Click in your admin interface to the area **Admin -> Packages**.

2. [Download the current version](https://github.com/rolfschmidt/Rolfs-TableSearch/releases) for the package which is compatible to your zammad version.

3. Install the package.

4. Run all displayed commands in the UI on your shell and restart your zammad service.

## Endpoints

### All tables

```bash
$ curl -s -uadmin@example.com:test http://ubuntu-rs:3000/api/v1/tables | jq .
{
  "active_job_locks": "ActiveJobLock",
  "activity_streams": "ActivityStream",
  "authorizations": "Authorization",
  "avatars": "Avatar",
  "calendars": "Calendar",
  "channels": "Channel",
  "chat_agents": "Chat::Agent",
  "chat_messages": "Chat::Message",
  "chat_sessions": "Chat::Session",
  "chats": "Chat",
  "core_workflows": "CoreWorkflow",
  "cti_caller_ids": "Cti::CallerId",
  "cti_logs": "Cti::Log",
  "data_privacy_tasks": "DataPrivacyTask",
  "email_addresses": "EmailAddress",
  "external_credentials": "ExternalCredential",
  "external_syncs": "ExternalSync",
  "groups": "Group",
  "history_attributes": "History::Attribute",
  "history_objects": "History::Object",
  "history_types": "History::Type",
  "histories": "History",
  "http_logs": "HttpLog",
  "import_jobs": "ImportJob",
  "jobs": "Job",
  "knowledge_base_answer_translation_contents": "KnowledgeBase::Answer::Translation::Content",
  "knowledge_base_answer_translations": "KnowledgeBase::Answer::Translation",
  "knowledge_base_answers": "KnowledgeBase::Answer",
  "knowledge_base_category_translations": "KnowledgeBase::Category::Translation",
  "knowledge_base_categories": "KnowledgeBase::Category",
  "knowledge_base_locales": "KnowledgeBase::Locale",
  "knowledge_base_menu_items": "KnowledgeBase::MenuItem",
  "knowledge_base_permissions": "KnowledgeBase::Permission",
  "knowledge_base_translations": "KnowledgeBase::Translation",
  "knowledge_bases": "KnowledgeBase",
  "ldap_sources": "LdapSource",
  "link_objects": "Link::Object",
  "link_types": "Link::Type",
  "links": "Link",
  "locales": "Locale",
  "macros": "Macro",
  "mentions": "Mention",
  "object_lookups": "ObjectLookup",
  "object_manager_attributes": "ObjectManager::Attribute",
  "online_notifications": "OnlineNotification",
  "organizations": "Organization",
  "overviews": "Overview",
  "package_migrations": "Package::Migration",
  "packages": "Package",
  "permissions": "Permission",
  "pgp_keys": "PGPKey",
  "postmaster_filters": "PostmasterFilter",
  "public_links": "PublicLink",
  "recent_views": "RecentView",
  "report_profiles": "Report::Profile",
  "roles": "Role",
  "roles_groups": "RoleGroup",
  "schedulers": "Scheduler",
  "sessions": "Session",
  "settings": "Setting",
  "signatures": "Signature",
  "slas": "Sla",
  "smime_certificates": "SMIMECertificate",
  "ssl_certificates": "SSLCertificate",
  "stats_stores": "StatsStore",
  "store_files": "Store::File",
  "store_objects": "Store::Object",
  "stores": "Store",
  "tag_items": "Tag::Item",
  "tag_objects": "Tag::Object",
  "tags": "Tag",
  "taskbars": "Taskbar",
  "templates": "Template",
  "text_modules": "TextModule",
  "ticket_article_flags": "Ticket::Article::Flag",
  "ticket_article_senders": "Ticket::Article::Sender",
  "ticket_article_types": "Ticket::Article::Type",
  "ticket_articles": "Ticket::Article",
  "ticket_counters": "Ticket::Counter",
  "ticket_flags": "Ticket::Flag",
  "ticket_priorities": "Ticket::Priority",
  "ticket_shared_draft_starts": "Ticket::SharedDraftStart",
  "ticket_shared_draft_zooms": "Ticket::SharedDraftZoom",
  "ticket_states": "Ticket::State",
  "ticket_state_types": "Ticket::StateType",
  "ticket_time_accounting_types": "Ticket::TimeAccounting::Type",
  "ticket_time_accountings": "Ticket::TimeAccounting",
  "tickets": "Ticket",
  "tokens": "Token",
  "translations": "Translation",
  "triggers": "Trigger",
  "type_lookups": "TypeLookup",
  "user_overview_sortings": "User::OverviewSorting",
  "user_two_factor_preferences": "User::TwoFactorPreference",
  "users": "User",
  "user_devices": "UserDevice",
  "groups_users": "UserGroup",
  "webhooks": "Webhook"
}
```

```bash
$ curl -s -uadmin@example.com:test http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?id=1 | jq .
[
  {
    "id": 1,
    "name": "1 low",
    "default_create": false,
    "ui_icon": "low-priority",
    "ui_color": "low-priority",
    "note": null,
    "active": true,
    "updated_by_id": 1,
    "created_by_id": 1,
    "created_at": "2023-09-04T10:45:15.514Z",
    "updated_at": "2023-09-04T10:45:15.548Z"
  }
]
```

## Current operators

### Exact match

Exact values match for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?id=1
http://ubuntu-rs:3000/api/v1/tables/tickets?id_not=1
```

### Date match

Range condtions for date columns.

`ge, gt, le, lt`

```
http://ubuntu-rs:3000/api/v1/tables/tickets?created_ge=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_gt=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_le=2023-09-04T10:45:16.017Z
http://ubuntu-rs:3000/api/v1/tables/tickets?created_lt=2023-09-04T10:45:16.017Z
```

### Search match

Fulltext search string columns.

`http://ubuntu-rs:3000/api/v1/tables/tickets?search=Welcome`

### Contains match

Contains for string columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?title_contains=Welcome
http://ubuntu-rs:3000/api/v1/tables/tickets?title_contains_not=Welcome
```

### Regex match

Regex match for string columns

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?name_regex=(low|high)
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?name_regex_not=(low|high)
```

### Empty match

Empty match for string columns.

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_empty=1
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_empty_not=1
```

### Null match

Empty match for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_null=1
http://ubuntu-rs:3000/api/v1/tables/ticket_priorities?note_null_not=1
```

### In array match

In array for all columns.

```
http://ubuntu-rs:3000/api/v1/tables/tickets?id_in=1,2,3
http://ubuntu-rs:3000/api/v1/tables/tickets?id_in_not=1,2,3
```

# LICENSE

MIT
