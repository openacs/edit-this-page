<?xml version="1.0"?>
<queryset>

<fullquery name="set_live_revision">
<querytext>
  update cr_items
     set live_revision = :revision_id, latest_revision = :revision_id
   where item_id = :item_id
</querytext>
</fullquery>

<fullquery name="revisions_to_delete">
<querytext>
  select revision_id
    from cr_revisions
   where item_id = :item_id
     and revision_id > :revision_id
   order by revision_id
</querytext>
</fullquery>
 
</queryset>
