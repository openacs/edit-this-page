<?xml version="1.0"?>
<queryset>

<fullquery name="etp::define_content_type.object_type_exists">      
<querytext>
	select 1 from acs_object_types
	 where object_type = :content_type
</querytext>
</fullquery>

<fullquery name="etp::define_content_type.attribute_exists">      
<querytext>
	    select attribute_id from acs_attributes
	     where object_type = :content_type
	       and attribute_name = :a_name
</querytext>
</fullquery>

<fullquery name="etp::make_page.page_exists">      
<querytext>
	    select 1 from cr_items
	     where parent_id = etp_get_folder_id(:package_id)
	       and name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_pa.get_page_attributes">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, 
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp_get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = i.live_revision
</querytext>
</fullquery>
 
<fullquery name="etp::get_pa.get_page_attributes_other_revision">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, 
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp_get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>

<fullquery name="etp::get_latest_revision_id.get_latest_revision_id">
<querytext>
	select max(revision_id) as revision_id
          from cr_revisions r, cr_items i
         where i.parent_id = etp_get_folder_id(:package_id)
           and i.name = :name
           and i.item_id = r.item_id
</querytext>
</fullquery>

<fullquery name="etp::get_live_revision_id.get_live_revision_id">
<querytext>
	select live_revision as revision_id
          from cr_items i
         where i.parent_id = etp_get_folder_id(:package_id)
           and i.name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_content_items.get_content_items">
<querytext>
     select * from (
	select $columns
          from cr_items i 
                 left join 
               cr_revisions r
            on (i.live_revision = r.revision_id)
         where i.parent_id = etp_get_folder_id(:package_id)
	   and i.name != 'index'
     ) as attributes
     where $extra_where_clauses
     order by $orderby
     $limit_clause
</querytext>
</fullquery>


<fullquery name="etp::get_subtopics.get_subtopics">
<querytext>
select child.name, child.node_id, child.object_id as package_id,
                   etp_package_title(child.object_id) as title,
                   etp_package_description(child.object_id) as description
  from site_nodes parent, site_nodes child, apm_packages p
 where parent.object_id = :package_id
   and child.parent_id = parent.node_id
   and child.object_id = p.package_id
   and p.package_key = 'edit-this-page'
</querytext>
</fullquery>
 

</queryset>
