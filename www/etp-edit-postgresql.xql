<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="transform_date">
<querytext>
	select to_char(to_date(:value, :date_format), 'YYYY-MM-DD')
</querytext>
</fullquery>

<fullquery name="get_standard_attribute">
<querytext>
        select $attribute as value, r.title as page_title, mime_type
          from cr_revisions r, cr_items i
         where i.parent_id = etp__get_folder_id(:package_id)
           and i.name = :name
           and i.item_id = r.item_id
	   and r.revision_id = :old_revision_id
</querytext>
</fullquery>

<fullquery name="get_extended_attribute">
<querytext>
	select etp__get_attribute_value(r.revision_id, :attribute_id) as value,
	       r.title as page_title
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp__get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :old_revision_id
</querytext>
</fullquery>


<fullquery name="create_new_revision">
<querytext>
select etp__create_new_revision(:package_id, :name, :user_id, :revision_id);
</querytext>
</fullquery>
 
</queryset>
