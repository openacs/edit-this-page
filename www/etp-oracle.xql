<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_current_page_attributes">
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, 
               content_revision.get_number(r.revision_id) as latest_revision,
               content_revision.get_number(i.live_revision) as live_revision,
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp.get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>

<fullquery name="get_content_pages">
<querytext>
  select name, title, rownum as sort_order
    from cr_items i, cr_revisions r
   where i.parent_id = etp.get_folder_id(:package_id)
     and i.name != 'index'
     and i.item_id = r.item_id
     and i.latest_revision = r.revision_id
   order by sort_order
</querytext>
</fullquery>
 
</queryset>
