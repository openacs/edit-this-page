<?xml version="1.0"?>
<queryset>

<fullquery name="publish_latest_revision">
<querytext>
update cr_items
set live_revision = :latest_revision_id
where live_revision = :live_revision_id
</querytext>
</fullquery>
 
</queryset>
