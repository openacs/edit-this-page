<?xml version="1.0"?>
<queryset>

<fullquery name="site_node_children">
<querytext>
  select count(1)
    from site_nodes
   where parent_id = :node_id
</querytext>
</fullquery>

<fullquery name="get_node_id">
<querytext>
  select node_id
    from site_nodes sn, cr_folders f
   where f.folder_id = :item_id
     and sn.object_id = f.package_id
</querytext>
</fullquery>

<fullquery name="matching_name">
<querytext>
  select count(1)
    from cr_items
   where parent_id = -400
     and name = (select name from cr_items where item_id = :item_id)
</querytext>
</fullquery>

<fullquery name="update_name">
<querytext>
  update cr_items 
     set name = 'Copy of ' || name
   where item_id = :item_id
</querytext>
</fullquery>

<fullquery name="trash_item">
<querytext>
  update cr_items
     set parent_id = -400, live_revision = NULL
   where item_id = :item_id
</querytext>
</fullquery>


</queryset>
