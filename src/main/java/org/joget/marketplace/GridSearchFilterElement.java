package org.joget.marketplace;

import java.util.Map;
import org.joget.apps.app.service.AppPluginUtil;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.model.Element;
import org.joget.apps.form.model.FormBuilderPaletteElement;
import org.joget.apps.form.model.FormData;
import org.joget.apps.form.service.FormUtil;
import org.joget.workflow.model.service.WorkflowUserManager;

public class GridSearchFilterElement extends Element implements FormBuilderPaletteElement{

    private final static String MESSAGE_PATH = "messages/GridSearchFilterElement";

    @Override
    public String renderTemplate(FormData formData, Map dataModel) {
        String template = "GridSearchFilterElement.ftl";
        String id = formData.getPrimaryKeyValue();

        Object gridColumns = getProperty("gridFieldSearch");
        if (gridColumns != null && gridColumns instanceof Object[]) {
            String requestJson = "";
            for (Object param : ((Object[]) gridColumns)) {
                Map paramMap = ((Map) param);

                if (requestJson.length() > 1) {
                    requestJson += ",";
                }
                requestJson += paramMap.get("column");
            }

            if (requestJson.length() > 2) {
                dataModel.put("gridColumns", requestJson);
            }
        }

        dataModel.put("id", id);
        String html = FormUtil.generateElementHtml(this, formData, template, dataModel);
        return html;
    }

    @Override
    public String getName() {
        return AppPluginUtil.getMessage("org.joget.marketplace.gridsearchfilter.element.pluginLabel", getClassName(), MESSAGE_PATH);
    }

    @Override
    public String getVersion() {
        return Activator.VERSION;
    }

    @Override
    public String getDescription() {
        return AppPluginUtil.getMessage("org.joget.marketplace.gridsearchfilter.element.pluginDesc", getClassName(), MESSAGE_PATH);
    }

    @Override
    public String getLabel() {
        return AppPluginUtil.getMessage("org.joget.marketplace.gridsearchfilter.element.pluginLabel", getClassName(), MESSAGE_PATH);
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/GridSearchFilterElement.json", null, true, MESSAGE_PATH);
    }

    @Override
    public String getFormBuilderCategory() {
        return "Marketplace";
    }

    @Override
    public int getFormBuilderPosition() {
        return 500;
    }

    @Override
    public String getFormBuilderIcon() {
        return "<i class=\"fas fa-filter\"></i>";
    }

    @Override
    public String getFormBuilderTemplate() {
        return "<label class='label'>"+getLabel()+"</label>";
    }
}