<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_symlink">
<querytext>
   begin
     :1 := etp.create_symlink(:package_id, :target_id);
   end;
</querytext>
</fullquery>

<fullquery name="all_pages">
<querytext>
	select i.item_id, i.name, etp.get_title(i.item_id, null) as title,
           replace(lpad(' ', (level - 1) * 4), ' ', '&nbsp;') as indent
        from cr_items i, acs_objects o
        where i.item_id = o.object_id
           and o.object_type in ('content_item', 'content_folder')
           and i.name != 'index'
           and i.item_id not in (select item_id 
                                 from cr_items
                                 start with parent_id = i.item_id
                                 connect by parent_id = prior item_id)
</querytext>
</fullquery>
 
</queryset>
