<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_symlink">
<querytext>
    select etp__create_symlink(:package_id, :target_id);
</querytext>
</fullquery>

<fullquery name="all_pages">
<querytext>
	select i.item_id, i.name, etp__get_title(i.item_id, null) as title,
               repeat('&nbsp;',(tree_level(i.tree_sortkey) - 1) * 4) as indent
          from cr_items i, acs_objects o, cr_items i2
         where i.item_id = o.object_id
           and o.object_type in ('content_item', 'content_folder')
           and i.name != 'index'
           and i2.item_id = -400
           and i.tree_sortkey not between i2.tree_sortkey and tree_right(i2.tree_sortkey)
         order by i.tree_sortkey
</querytext>
</fullquery>
 
</queryset>
