<#assign alignmentClass = "justify-content-end">
<#if element.properties.fieldPosition??>
    <#if element.properties.fieldPosition == "left">
        <#assign alignmentClass = "justify-content-start">
    <#elseif element.properties.fieldPosition == "center">
        <#assign alignmentClass = "justify-content-center">
    </#if>
</#if>

<div class="form-cell d-flex ${alignmentClass}" ${elementMetaData!}>
    <#if (element.properties.readonly! == 'true' && element.properties.readonlyLabel! == 'true') >
        <div class="form-cell-value"><span>${value!?html}</span></div>
        <input id="${elementParamName!}" name="${elementParamName!}" type="hidden" value="${value!?html}" />
    <#else>
        <input id="${elementParamName!}" name="${elementParamName!}" type="text" placeholder="${element.properties.placeholder!?html}" size="${element.properties.size!}" value="${value!?html}" maxlength="${element.properties.maxlength!}" <#if error??>class="form-error-cell"</#if> <#if element.properties.readonly! == 'true'>readonly</#if> />
    </#if>
</div>


<#if id?has_content>
<script>
document.addEventListener('keydown', function(event) {
    const searchInput = document.getElementById('${elementParamName!}');
    const table = document.getElementsByName('${element.properties.gridField!}')[0];

    searchInput.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();

            const filter = searchInput.value.toLowerCase();
            const rows = table.querySelectorAll('tbody tr.grid-row');

            rows.forEach(row => {
                let cell = row.querySelector('span[column_key="${element.properties.gridFieldSearch!}"]');

                if (!cell) {
                    cell = row.querySelector('span[name="grid_${element.properties.gridFieldSearch!}"]');
                }

                if (cell) {
                    const text = cell.textContent.trim().toLowerCase();
                    const matches = text.includes(filter);
                    row.classList.toggle('pg-tr-show', matches);
                    row.classList.toggle('pg-tr-hide', !matches);
                }
            });
        }
    });
});
</script>
</#if>
