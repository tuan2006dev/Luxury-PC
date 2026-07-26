package poly.edu.config.profiler;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class ProfilerAspect {

    @Around("execution(* poly.edu.repository..*(..))")
    public Object profileRepository(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed();
        } finally {
            long time = System.currentTimeMillis() - start;
            SimpleProfiler.logRepository(pjp.getSignature().getDeclaringType().getSimpleName() + "." + pjp.getSignature().getName(), time);
        }
    }

    @Around("execution(* poly.edu.service..*(..))")
    public Object profileService(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed();
        } finally {
            long time = System.currentTimeMillis() - start;
            SimpleProfiler.logService(pjp.getSignature().getDeclaringType().getSimpleName() + "." + pjp.getSignature().getName(), time);
        }
    }

    @Around("execution(* poly.edu.controller..*(..))")
    public Object profileController(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed();
        } finally {
            long time = System.currentTimeMillis() - start;
            SimpleProfiler.logController(pjp.getSignature().getDeclaringType().getSimpleName() + "." + pjp.getSignature().getName(), time);
        }
    }
}
