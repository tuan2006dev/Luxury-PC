package poly.edu.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;
import poly.edu.entity.User;

import java.util.Collection;
import java.util.Map;

public class CustomOAuth2User implements OAuth2User {

    private final OAuth2User oauth2User;
    private final String clientName;
    private User dbUser;
    private Collection<? extends GrantedAuthority> authorities;

    public CustomOAuth2User(OAuth2User oauth2User, String clientName) {
        this(oauth2User, clientName, null, null);
    }

    public CustomOAuth2User(OAuth2User oauth2User, String clientName, User dbUser, Collection<? extends GrantedAuthority> authorities) {
        this.oauth2User = oauth2User;
        this.clientName = clientName;
        this.dbUser = dbUser;
        this.authorities = authorities;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return oauth2User != null ? oauth2User.getAttributes() : Map.of();
    }

    @Override
    @SuppressWarnings("unchecked")
    public <A> A getAttribute(String name) {
        if (oauth2User != null) {
            Object val = oauth2User.getAttribute(name);
            if (val != null) {
                return (A) val;
            }
            Map<String, Object> attrs = oauth2User.getAttributes();
            if (attrs != null && attrs.containsKey(name)) {
                return (A) attrs.get(name);
            }
        }
        return null;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (authorities != null && !authorities.isEmpty()) {
            return authorities;
        }
        return oauth2User != null ? oauth2User.getAuthorities() : java.util.Collections.emptyList();
    }

    @Override
    public String getName() {
        if (dbUser != null) {
            if (dbUser.getUsername() != null && !dbUser.getUsername().isBlank()) {
                return dbUser.getUsername();
            }
            if (dbUser.getFullName() != null && !dbUser.getFullName().isBlank()) {
                return dbUser.getFullName();
            }
        }
        String nameAttr = getAttribute("name");
        return nameAttr != null ? nameAttr : (getEmail() != null ? getEmail() : "OAuth2User");
    }

    public String getUsername() {
        if (dbUser != null && dbUser.getUsername() != null && !dbUser.getUsername().isBlank()) {
            return dbUser.getUsername();
        }
        return getName();
    }

    public String getEmail() {
        if (dbUser != null && dbUser.getEmail() != null && !dbUser.getEmail().isBlank()) {
            return dbUser.getEmail();
        }
        return getAttribute("email");
    }

    public String getProviderName() {
        return clientName;
    }

    public User getDbUser() {
        return dbUser;
    }

    public void setDbUser(User dbUser) {
        this.dbUser = dbUser;
    }

    public void setAuthorities(Collection<? extends GrantedAuthority> authorities) {
        this.authorities = authorities;
    }
}

