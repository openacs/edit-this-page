<master src="../www/etp-master">
<property name="title">@pa.title;noquote@</property>
<property name="context_bar">@pa.context_bar;noquote@</property>

<if @pa.content@ not nil>
@pa.content@
</if>

<p>

<multiple name="content_items">
<b>@content_items.section@</b>
<blockquote>
<group column="section">
<a href="@content_items.name@">@content_items.title@</a><br>
<i>@content_items.byline@</i>
<br>
</group>
</blockquote>
<p>
</multiple>
