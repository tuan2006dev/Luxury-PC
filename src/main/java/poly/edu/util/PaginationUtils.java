package poly.edu.util;

import org.springframework.ui.Model;

import java.util.Collections;
import java.util.List;

public class PaginationUtils {

    public static final int DEFAULT_PAGE_SIZE = 8;

    public static <T> List<T> paginate(List<T> allItems, Integer page, int pageSize, Model model) {
        if (allItems == null) {
            allItems = Collections.emptyList();
        }
        int totalItems = allItems.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        int currentPage = (page == null || page < 1) ? 1 : page;
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);

        List<T> pageItems;
        if (fromIndex >= totalItems || fromIndex < 0) {
            pageItems = Collections.emptyList();
        } else {
            pageItems = allItems.subList(fromIndex, toIndex);
        }

        int startItem = totalItems == 0 ? 0 : fromIndex + 1;
        int endItem = toIndex;

        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("startItem", startItem);
        model.addAttribute("endItem", endItem);

        return pageItems;
    }

    public static <T> List<T> paginate(List<T> allItems, Integer page, Model model) {
        return paginate(allItems, page, DEFAULT_PAGE_SIZE, model);
    }
}
