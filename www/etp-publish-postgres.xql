<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="set_publish_date">
<querytext>
update cr_revisions
set publish_date = now()
where revision_id = :latest_revision_id
</querytext>
</fullquery>

<fullquery name="set_audit_info">
<querytext>
update acs_objects
set modifying_user = :user_id,
    last_modified = now()
where object_id = :latest_revision_id
</querytext>
</fullquery>


</queryset>
