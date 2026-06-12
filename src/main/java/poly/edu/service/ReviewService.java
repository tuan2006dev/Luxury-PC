package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import poly.edu.dao.ReviewDAO;
import poly.edu.entity.Review;
import java.util.List;

@Service
public class ReviewService {
    @Autowired
    ReviewDAO reviewDAO;

    public List<Review> getLatestReviews() {
        return reviewDAO.findTop10ByOrderByCreatedAtDesc();
    }
}
