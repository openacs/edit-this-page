<?xml version="1.0"?>
<queryset>

<fullquery name="get_node_id">
<querytext>
  select node_id
    from site_nodes sn, cr_folders f
   where f.folder_id = :item_id
     and sn.object_id = f.package_id
</querytext>
</fullquery>


<fullquery name="trash_item">
<querytext>
  update cr_items
     set parent_id = -400
   where item_id = :item_id
</querytext>
</fullquery>


</queryset>
