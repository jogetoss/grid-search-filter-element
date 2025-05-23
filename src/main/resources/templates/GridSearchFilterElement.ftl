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
        <input id="${elementParamName!}" name="${elementParamName!}" type="text" data-grid-name="${element.properties.gridField!}"  data-columns="${gridColumns!}" data-search-all="${element.properties.searchAllColumns!}" placeholder="${element.properties.placeholder!?html}" size="${element.properties.size!}" value="${value!?html}" maxlength="${element.properties.maxlength!}" <#if error??>class="form-error-cell"</#if> <#if element.properties.readonly! == 'true'>readonly</#if> />
    </#if>
</div>


<#if id?has_content>
<script>
function initializeGridSearch(searchInput) {
    if (searchInput.dataset.gridInitialized === "true") return;
    searchInput.dataset.gridInitialized = "true";

    var gridName = searchInput.getAttribute("data-grid-name");
    var searchAllColumns = searchInput.getAttribute("data-search-all") === "true";
    var columnList = searchInput.getAttribute("data-columns").split(',').map(col => col.trim());

    var gridContainer = document.querySelector('div[name="' + gridName + '"]');
    var table = gridContainer.querySelector("table");
    var rows = Array.prototype.slice.call(table.querySelectorAll("tbody tr.grid-row"));
    var paginationId = gridContainer.getAttribute("data-pagination-container");
    var paginationContainer = document.getElementById(paginationId);

    var rowsPerPage = rows.filter(function(row) {
        return row.style.display !== "none" && !row.classList.contains("pg-tr-hide");
    }).length || 1;

    gridContainer.setAttribute("data-grid-rows", rowsPerPage);

    var currentPage = 1;

    function filterRows() {
        var filter = searchInput.value.trim().toLowerCase();
        var matchCount = 0;

        rows.forEach(function(row) {
            var matches = false;

            if (searchAllColumns) {
                var rowText = Array.from(row.querySelectorAll("span.grid-cell"))
                                   .map(cell => cell.textContent.toLowerCase())
                                   .join(" ");
                matches = rowText.includes(filter);
            } else {
                var combined = columnList.map(function(field) {
                    var cell = row.querySelector('span.grid-cell[name="grid_' + field + '"]');
                    if(!cell){
                        cell = row.querySelector('span.grid-cell[column_key="' + field + '"]');
                    }
                    return cell ? cell.textContent.toLowerCase() : "";
                }).join(" ");
                matches = combined.includes(filter);
            }

            row.classList.toggle("pg-tr-show", matches);
            row.classList.toggle("pg-tr-hide", !matches);
            if (matches) matchCount++;
        });

        currentPage = 1;
        applyPagination();
        renderPagination(matchCount);
    }

    function applyPagination() {
        var visibleRows = rows.filter(row => row.classList.contains("pg-tr-show"));

        visibleRows.forEach(row => row.style.display = "none");

        var start = (currentPage - 1) * rowsPerPage;
        var end = start + rowsPerPage;

        visibleRows.slice(start, end).forEach(row => row.style.display = "");
    }

   function renderPagination(totalVisible) {
        if (searchInput.value.trim() !== "") {
            var existingNavigator = gridContainer.querySelector("p.pg-navigator");
            if (existingNavigator) {
                existingNavigator.style.display = "none";
            }
        }
        if (!paginationContainer) {
            paginationContainer = document.createElement("div");
            paginationContainer.id = paginationId || ("pagination-controls-" + gridName);
            gridContainer.appendChild(paginationContainer);
        }

        paginationContainer.innerHTML = "";

        var pageCount = Math.ceil(totalVisible / rowsPerPage);
        if (pageCount <= 1) return;

        // Build the pagination HTML
        var p = document.createElement("p");
        p.className = "pg-navigator";

        // Prev button
        var prev = document.createElement("span");
        prev.className = "pg-prev";
        prev.style.cursor = "pointer";
        prev.textContent = " « ";
        prev.addEventListener("click", function () {
            if (currentPage > 1) {
                currentPage--;
                applyPagination();
                renderPagination(totalVisible);
            }
        });
        p.appendChild(prev);

        // Separator
        p.appendChild(document.createTextNode(" | "));

        // Page numbers
        for (let i = 1; i <= pageCount; i++) {
            var span = document.createElement("span");
            span.className = "pg-normal";
            if (i === currentPage) span.classList.add("pg-current");
            span.setAttribute("rel", i);
            span.style.cursor = "pointer";
            span.textContent = i;
            span.addEventListener("click", function () {
                currentPage = i;
                applyPagination();
                renderPagination(totalVisible);
            });
            p.appendChild(span);

            if (i < pageCount) {
                p.appendChild(document.createTextNode(" | "));
            }
        }

        // Next button
        var next = document.createElement("span");
        next.className = "pg-next";
        next.style.cursor = "pointer";
        next.textContent = " » ";
        next.addEventListener("click", function () {
            if (currentPage < pageCount) {
                currentPage++;
                applyPagination();
                renderPagination(totalVisible);
            }
        });
        p.appendChild(document.createTextNode(" | "));
        p.appendChild(next);

        // Append the pagination element
        paginationContainer.appendChild(p);
    }


    searchInput.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            filterRows();
        }
    });

    searchInput.addEventListener("input", function () {
        if (searchInput.value === "") {
            filterRows();
        }
    });

    rows.forEach(row => row.classList.add("pg-tr-show"));
    applyPagination();
    renderPagination(rowsPerPage);
}

document.body.addEventListener("keydown", function(event) {
  const target = event.target;
  if (
    target.tagName === "INPUT" &&
    target.hasAttribute("data-grid-name") &&
    !target.dataset.gridInitialized
  ) {
    initializeGridSearch(target);
  }
});

</script>

</#if>
