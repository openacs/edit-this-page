<master src="/packages/edit-this-page/www/etp-master">
<property name="title">@pa.title@</property>
<property name="context_bar">@pa.context_bar@</property>

<p>

<if @pa.content@ not nil>
@pa.content@
<p>
</if>

Frequently Asked Questions:
<ol>
<multiple name="content_items">
<li>
<a href="#@content_items.rownum@">@content_items.title@</a>
</li>
</multiple>
</ol>
<hr>
<p>

Questions and Answers:
<ol>
<multiple name="content_items">
<a name="@content_items.rownum@"></a>
<li>
<b>Q:</b> <em>@content_items.title@</em>
<p>
<b>A:</b> 
@content_items.content@
<p>
</li>
</multiple>
</ol>
