package poly.edu.service;

public class VietQrManualConfirmationException extends RuntimeException {

    public VietQrManualConfirmationException() {
        super("Thanh to\u00e1n VietQR ch\u1ec9 \u0111\u01b0\u1ee3c x\u00e1c nh\u1eadn t\u1ef1 \u0111\u1ed9ng qua SePay webhook.");
    }
}
