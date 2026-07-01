package poly.edu.dto;

import java.util.List;

public class GeminiResponseDto {

    private List<CandidateDto> candidates;

    public List<CandidateDto> getCandidates() {
        return candidates;
    }

    public void setCandidates(List<CandidateDto> candidates) {
        this.candidates = candidates;
    }

    public static class CandidateDto {
        private ContentDto content;

        public ContentDto getContent() {
            return content;
        }

        public void setContent(ContentDto content) {
            this.content = content;
        }
    }

    public static class ContentDto {
        private List<PartDto> parts;

        public List<PartDto> getParts() {
            return parts;
        }

        public void setParts(List<PartDto> parts) {
            this.parts = parts;
        }
    }

    public static class PartDto {
        private String text;

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }
    }
}
