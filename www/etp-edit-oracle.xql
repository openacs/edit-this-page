<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_standard_attribute">
<querytext>
        select $attribute as value, r.title as page_title
          from cr_revisions r, cr_items i
         where i.parent_id = etp.get_folder_id(:package_id)
           and i.name = :name
           and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>

<fullquery name="get_extended_attribute">
<querytext>
	select etp.get_attribute_value(r.revision_id, :attribute_id) as value,
	       r.title as page_title
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp.get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>
 
</queryset>
