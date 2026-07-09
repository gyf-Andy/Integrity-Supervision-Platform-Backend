package com.integrity.job.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.integrity.job.domain.SysJobVo;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Treeselect树结构实体类
 *
 * @author Integrity-Supervision-Platform
 */
@Data
@ToString
@EqualsAndHashCode
@NoArgsConstructor
public class TreeSelect implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 节点ID
     */
    private String id;

    /**
     * 节点名称
     */
    private String label;

    /**
     * 子节点
     */
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<TreeSelect> children;

    public TreeSelect(SysJobVo jobVo) {
        this.id = jobVo.getJobId();
        this.label = jobVo.getJobName();
        this.children = jobVo.getChildren().stream().map(TreeSelect::new).collect(Collectors.toList());
    }
}

