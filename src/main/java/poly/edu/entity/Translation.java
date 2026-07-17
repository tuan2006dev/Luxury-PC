package poly.edu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "translations", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"[key]", "lang"})
})
public class Translation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "[key]", nullable = false, length = 100)
    private String key;

    @Column(name = "lang", nullable = false, length = 10)
    private String lang;

    @Column(name = "value", nullable = false, columnDefinition = "TEXT")
    private String value;

    public Translation() {
    }

    public Translation(String key, String lang, String value) {
        this.key = key;
        this.lang = lang;
        this.value = value;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
