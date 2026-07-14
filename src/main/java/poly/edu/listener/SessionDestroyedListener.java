package poly.edu.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.stereotype.Component;
import poly.edu.dao.UserSessionDAO;
import poly.edu.entity.UserSession;
import java.util.Optional;

@Component
public class SessionDestroyedListener implements ApplicationListener<SessionDestroyedEvent> {

    private final UserSessionDAO userSessionDAO;

    public SessionDestroyedListener(UserSessionDAO userSessionDAO) {
        this.userSessionDAO = userSessionDAO;
    }

    @Override
    public void onApplicationEvent(SessionDestroyedEvent event) {
        String sessionId = event.getId();
        Optional<UserSession> userSessionOpt = userSessionDAO.findBySessionId(sessionId);
        if (userSessionOpt.isPresent()) {
            UserSession userSession = userSessionOpt.get();
            userSession.setIsExpired(true);
            userSessionDAO.save(userSession);
        }
    }
}
