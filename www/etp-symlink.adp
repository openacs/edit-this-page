<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<multiple name="all_pages">
@all_pages.indent@
<if @all_pages.item_id@ eq @target_id@>
<em>@all_pages.title@</em><br>
</if>
<else>
<a href="etp-symlink?item_id=@item_id@&target_id=@all_pages.item_id@">@all_pages.title@</a><br>
</else>
</multiple>

<p>
