<?xml version="1.0"?>

<queryset>

<fullquery name="etp::revision_url.revision_url">
	<querytext>
        select name as url, parent_id as package_id
        from cr_items 
	where live_revision = :object_id
	</querytext>
</fullquery>


<fullquery name="etp::revision_datasource.revision_datasource">
      <querytext>
       	select r.revision_id as object_id,
	       r.title as title,
	       content as content,
	       'text/html' as mime,
	       '' as keywords,
	       'text' as storage_type
	from cr_revisions r
	       where revision_id = :object_id
      </querytext>
</fullquery>

</queryset>
