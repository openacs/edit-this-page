<?xml version="1.0"?>
<queryset>

<fullquery name="set_publish_date">
<querytext>
update cr_revisions
set publish_date = sysdate
where revision_id = :latest_revision_id
</querytext>
</fullquery>

<fullquery name="set_audit_info">
<querytext>
update acs_objects
set modifying_user = :user_id,
    last_modified = sysdate
where object_id = :latest_revision_id
</querytext>
</fullquery>

</queryset>
