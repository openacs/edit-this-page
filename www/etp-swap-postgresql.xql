<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_prev_key">
<querytext>
  select tree_sortkey, item_id
    from cr_items
   where parent_id = etp_get_folder_id(:package_id)
     and tree_sortkey < :sort_key
   order by tree_sortkey desc
</querytext>
</fullquery>
 
<fullquery name="get_all_keys">
<querytext>
  select tree_sortkey, item_id
    from cr_items
   where tree_sortkey >= :prev_sort_key
   order by tree_sortkey
</querytext>
</fullquery>

<fullquery name="update_key">
<querytext>
  update cr_items
     set tree_sortkey = :new_sortkey
   where item_id = :item_id
</querytext>
</fullquery>

</queryset>
