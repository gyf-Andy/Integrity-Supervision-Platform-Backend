package com.integrity.flow.controller;

import com.integrity.common.core.constant.HttpStatus;
import com.integrity.common.core.domain.R;
import com.integrity.common.core.web.controller.BaseController;
import com.integrity.common.core.web.page.PageDomain;
import com.integrity.common.core.web.page.TableDataInfo;
import com.integrity.common.core.web.page.TableSupport;
import com.integrity.common.log.annotation.Log;
import com.integrity.common.log.enums.BusinessType;
import com.integrity.common.security.annotation.RequiresPermissions;
import lombok.RequiredArgsConstructor;
import org.dom4j.Document;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.dromara.warm.flow.core.entity.Definition;
import org.dromara.warm.flow.core.service.DefService;
import org.dromara.warm.flow.core.utils.page.Page;
import org.dromara.warm.flow.orm.entity.FlowDefinition;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 流程定义Controller
 *
 * @author hh
 * @date 2023-04-11
 */
@Validated
@RestController
@RequestMapping("/definition")
@RequiredArgsConstructor
public class DefController extends BaseController {
    private final DefService defService;

    /**
     * 分页查询流程定义列表
     */
    @GetMapping("/list")
    public TableDataInfo list(FlowDefinition flowDefinition) {
        // flow组件自带分页功能
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Page<Definition> page = Page.pageOf(pageDomain.getPageNum(), pageDomain.getPageSize());
        page = defService.orderByCreateTime().desc().page(flowDefinition, page);
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setMsg("查询成功");
        rspData.setRows(page.getList());
        rspData.setTotal(page.getTotal());
        return rspData;
    }


    /**
     * 获取流程定义详细信息
     */
    @RequiresPermissions("flow:definition:query")
    @GetMapping(value = "/{id}")
    public R<Definition> getInfo(@PathVariable("id") Long id) {
        return R.ok(defService.getById(id));
    }

    /**
     * 新增流程定义
     */
    @RequiresPermissions("flow:definition:add")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @PostMapping
    @Transactional(rollbackFor = Exception.class)
    public R<Boolean> add(@RequestBody FlowDefinition flowDefinition) {
        return R.ok(defService.saveAndInitNode(flowDefinition));
    }

    /**
     * 发布流程定义
     */
    @RequiresPermissions("flow:definition:publish")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @GetMapping("/publish/{id}")
    @Transactional(rollbackFor = Exception.class)
    public R<Boolean> publish(@PathVariable("id") Long id) {
        return R.ok(defService.publish(id));
    }

    /**
     * 取消发布流程定义
     */
    @RequiresPermissions("flow:definition:publish")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @GetMapping("/unPublish/{id}")
    @Transactional(rollbackFor = Exception.class)
    public R<Void> unPublish(@PathVariable("id") Long id) {
        defService.unPublish(id);
        return R.ok();
    }

    /**
     * 修改流程定义
     */
    @RequiresPermissions("flow:definition:edit")
    @Log(title = "流程定义", businessType = BusinessType.UPDATE)
    @PutMapping
    @Transactional(rollbackFor = Exception.class)
    public R<Boolean> edit(@RequestBody FlowDefinition flowDefinition) {
        return R.ok(defService.updateById(flowDefinition));
    }

    /**
     * 删除流程定义
     */
    @RequiresPermissions("flow:definition:remove")
    @Log(title = "流程定义", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    @Transactional(rollbackFor = Exception.class)
    public R<Boolean> remove(@PathVariable List<Long> ids) {
        return R.ok(defService.removeDef(ids));
    }

    /**
     * 复制流程定义
     */
    @RequiresPermissions("flow:definition:publish")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @GetMapping("/copyDef/{id}")
    @Transactional(rollbackFor = Exception.class)
    public R<Boolean> copyDef(@PathVariable("id") Long id) {
        return R.ok(defService.copyDef(id));
    }

    @Log(title = "流程定义", businessType = BusinessType.IMPORT)
    @RequiresPermissions("flow:definition:importDefinition")
    @PostMapping("/importDefinition")
    @Transactional(rollbackFor = Exception.class)
    public R<Void> importDefinition(MultipartFile file) throws Exception {
        defService.importXml(file.getInputStream());
        return R.ok();
    }

    @Log(title = "流程定义", businessType = BusinessType.EXPORT)
    @RequiresPermissions("flow:definition:exportDefinition")
    @PostMapping("/exportDefinition/{id}")
    public void exportDefinition(@PathVariable("id") Long id, HttpServletResponse response) throws Exception {
        Document document = defService.exportXml(id);
        // 设置生成xml的格式
        OutputFormat of = OutputFormat.createPrettyPrint();
        // 设置编码格式
        of.setEncoding("UTF-8");
        of.setIndent(true);
        of.setIndent("    ");
        of.setNewlines(true);

        // 创建一个xml文档编辑器
        XMLWriter writer = new XMLWriter(response.getOutputStream(), of);
        writer.setEscapeText(false);
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/x-msdownload");
        response.setHeader("Content-Disposition", "attachment;");
        writer.write(document);
        writer.close();
    }

    /**
     * 查询流程图
     *
     * @param definitionId
     * @return
     * @throws IOException
     */
    @GetMapping("/flowChartNoColor/{definitionId}")
    public R<String> flowChartNoColor(@PathVariable("definitionId") Long definitionId) throws IOException {
        return R.ok(defService.flowChartNoColor(definitionId));
    }

    /**
     * 查询流程图
     *
     * @param instanceId
     * @return
     * @throws IOException
     */
    @GetMapping("/flowChart/{instanceId}")
    public R<String> flowChart(@PathVariable("instanceId") Long instanceId) throws IOException {
        return R.ok(defService.flowChart(instanceId));
    }

    /**
     * 激活流程
     *
     * @param definitionId
     * @return
     */
    @GetMapping("/active/{definitionId}")
    public R<Boolean> active(@PathVariable("definitionId") Long definitionId) {
        return R.ok(defService.active(definitionId));
    }

    /**
     * 挂起流程
     *
     * @param definitionId
     * @return
     */
    @GetMapping("/unActive/{definitionId}")
    public R<Boolean> unActive(@PathVariable("definitionId") Long definitionId) {
        return R.ok(defService.unActive(definitionId));
    }
}
