<?xml version="1.0"?>
<queryset>

<fullquery name="get_item_id">
<querytext>
  select item_id
    from cr_items
   where parent_id = etp_get_folder_id(:package_id)
     and name = :name
</querytext>
</fullquery>
 
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
 
<fullquery name="get_revision_count">
<querytext>
    select count(1) as revision_count
    from cr_revisions r, cr_items i
    where r.item_id = i.item_id
    and i.parent_id = etp_get_folder_id(:package_id)
    and i.name = :name
    and r.revision_id > :revision_id
</querytext>
</fullquery>

</queryset>
