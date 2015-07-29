<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="etp::revision_url.package_url">
    <querytext>
select site_node__url(node_id) as package_url from site_nodes where object_id = (select package_id from cr_folders where folder_id= (select parent_id from cr_items where latest_revision = :object_id))
    </querytext>
</fullquery>

<fullquery name="etp::define_content_type.object_type_create">      
<querytext>
	    select acs_object_type__create_type (
	        :content_type,
	        :pretty_name,
	        :pretty_plural,
	        'etp_page_revision',
	        null,
	        null,
	        null,
	        'f',
	        null,
	        null
	    )
</querytext>
</fullquery>

<fullquery name="etp::define_content_type.attribute_create">      
<querytext>
		select acs_attribute__create_attribute (
		    :content_type,
		    :a_name,
		    :a_datatype,
		    :a_pretty_name,
		    :a_pretty_plural,
		    null,
		    null,
		    :a_default,
		    1,
		    1,
		    null,
		    'generic',
		    'f'
		)
</querytext>
</fullquery>

<fullquery name="etp::make_page.page_create">      
<querytext>
	select etp__create_page(
	  :item_id,
	  :package_id,
	  :name,
          :title,
	  :content_type
	)
</querytext>
</fullquery>

<fullquery name="etp::register_page.package_id_from_url">      
<querytext>
	    select object_id as package_id
	      from site_nodes
	     where node_id = site_node__node_id(:url_stub, null)
</querytext>
</fullquery>

<fullquery name="etp::make_page.page_exists">      
<querytext>
	    select 1 from cr_items
	     where parent_id = etp__get_folder_id(:package_id)
	       and name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_pa.get_page_attributes">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, r.mime_type,
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp__get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = i.live_revision
</querytext>
</fullquery>
 
<fullquery name="etp::get_pa.get_page_attributes_other_revision">      
<querytext>
	select i.item_id, i.name, r.revision_id, r.title, r.mime_type,
	       r.description, r.publish_date, r.content $extended_attributes
	  from cr_items i, cr_revisions r
	 where i.parent_id = etp__get_folder_id(:package_id)
	   and i.name = :name
	   and i.item_id = r.item_id
	   and r.revision_id = :revision_id
</querytext>
</fullquery>

<fullquery name="etp::get_latest_revision_id.get_latest_revision_id">
<querytext>
	select max(revision_id) as revision_id
          from cr_revisions r, cr_items i
         where i.parent_id = etp__get_folder_id(:package_id)
           and i.name = :name
           and i.item_id = r.item_id
</querytext>
</fullquery>

<fullquery name="etp::get_live_revision_id.get_live_revision_id">
<querytext>
	select live_revision as revision_id
          from cr_items i
         where i.parent_id = etp__get_folder_id(:package_id)
           and i.name = :name
</querytext>
</fullquery>

<fullquery name="etp::get_content_items.get_content_items">
<querytext>
   select * from
     (select $columns
      from cr_items i left join cr_revisions r on (i.live_revision = r.revision_id)
      where i.parent_id = :folder_id and i.name != 'index'
     ) attributes
   where $extra_where_clauses
   order by $orderby
   $limit_clause
</querytext>
</fullquery>


<fullquery name="etp::get_subtopics.get_subtopics">
<querytext>
select child.name, child.node_id, child.object_id as package_id,
                   etp__get_title(f.folder_id,NULL) as title,
                   etp__get_description(f.folder_id,NULL) as description,
	           site_node__url(child.node_id) as url
  from site_nodes parent, site_nodes child, apm_packages p,
  cr_folders f
 where parent.object_id = :package_id
   and child.parent_id = parent.node_id
   and child.object_id = p.package_id
   and p.package_key = 'edit-this-page'
   and f.package_id=p.package_id
</querytext>
</fullquery>

<partialquery name="etp::get_attribute_lookup_sql.lookup_sql_clause">
  <querytext>
    etp__get_attribute_value(r.revision_id, $attribute_id)
  </querytext>
</partialquery>

<partialquery name="etp::get_content_items.gci_orderby">
   <querytext>
      sort_order
   </querytext>
</partialquery>

<partialquery name="etp::get_content_items.gci_columns_clause">
   <querytext>
      i.item_id, i.name, tree_sortkey as sort_order,
      to_char(r.publish_date, 'Mon DD, YYYY') as publish_date,
      (select object_type from acs_objects 
       where object_id = i.item_id) as object_type,
             etp__get_relative_url(i.item_id, i.name) as url,
             etp__get_title(i.item_id, r.title) as title,
             etp__get_description(i.item_id, r.description) as description      
   </querytext>
</partialquery>

<fullquery name="etp::get_folder_id.get_folder_id">
	<querytext>
	select etp__get_folder_id(:package_id)
	</querytext>
</fullquery>

</queryset>
