package poly.edu.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "shared_builds")
public class SharedBuild implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "share_code", length = 15)
    private String shareCode;

    private String name;

    @Column(name = "case_id", length = 50)
    private String caseId;

    @Column(name = "mainboard_id", length = 50)
    private String mainboardId;

    @Column(name = "cpu_id", length = 50)
    private String cpuId;

    @Column(name = "cooler_id", length = 50)
    private String coolerId;

    @Column(name = "ram_id", length = 50)
    private String ramId;

    @Column(name = "storage_id", length = 50)
    private String storageId;

    @Column(name = "gpu_id", length = 50)
    private String gpuId;

    @Column(name = "psu_id", length = 50)
    private String psuId;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt = new Date();

    public SharedBuild() {
    }

    public String getShareCode() {
        return shareCode;
    }

    public void setShareCode(String shareCode) {
        this.shareCode = shareCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCaseId() {
        return caseId;
    }

    public void setCaseId(String caseId) {
        this.caseId = caseId;
    }

    public String getMainboardId() {
        return mainboardId;
    }

    public void setMainboardId(String mainboardId) {
        this.mainboardId = mainboardId;
    }

    public String getCpuId() {
        return cpuId;
    }

    public void setCpuId(String cpuId) {
        this.cpuId = cpuId;
    }

    public String getCoolerId() {
        return coolerId;
    }

    public void setCoolerId(String coolerId) {
        this.coolerId = coolerId;
    }

    public String getRamId() {
        return ramId;
    }

    public void setRamId(String ramId) {
        this.ramId = ramId;
    }

    public String getStorageId() {
        return storageId;
    }

    public void setStorageId(String storageId) {
        this.storageId = storageId;
    }

    public String getGpuId() {
        return gpuId;
    }

    public void setGpuId(String gpuId) {
        this.gpuId = gpuId;
    }

    public String getPsuId() {
        return psuId;
    }

    public void setPsuId(String psuId) {
        this.psuId = psuId;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
