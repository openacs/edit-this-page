<?xml version="1.0"?>
<queryset>

<fullquery name="clear_revisions">
<querytext>
update cr_items set live_revision=null, latest_revision=null
where item_id = :item_id
</querytext>
</fullquery>

</queryset>
