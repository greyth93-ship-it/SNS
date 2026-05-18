package com.sns.app.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;

import com.sns.app.member.MemberServiceImpl;
import com.sns.app.security.LoginFailHandler;
import com.sns.app.security.LoginSuccessHandler;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Autowired
	private LoginSuccessHandler successHandler;
	
	@Autowired
	private LoginFailHandler failHandler;
	
	@Autowired
	private MemberServiceImpl memberServiceImpl;
	
	
	@Bean
	WebSecurityCustomizer customizer() {
		return web ->{
			web.ignoring()
				.requestMatchers("/css/**")
				.requestMatchers("/images/**","/img/**","/js/**","/vender/**")
				.requestMatchers("/files/**", "/fileDown/**")
				;
		};
	}
	@Bean
	SecurityFilterChain securityFilterChain(HttpSecurity security) throws Exception{
		security
			.cors(cors->{cors.disable();})
			.csrf(csrf->{csrf.disable();})
			.authorizeHttpRequests(auth->{
				auth
					.requestMatchers("/member/mypage").authenticated()
					.requestMatchers("/chat/*").authenticated()
					.requestMatchers("/member/*").permitAll()
					.anyRequest().permitAll()
					;
			})
			.formLogin(form->{
				form
					.loginPage("/member/login")
					.loginProcessingUrl("/member/login")
					.successHandler(successHandler)
					.failureHandler(failHandler)
					;
			})
			.rememberMe(remember->{
				remember
					.rememberMeParameter("rememberMe")
					.key("rememberKey")
					.tokenValiditySeconds(60*60*24*30)
					.userDetailsService(memberServiceImpl)
					.authenticationSuccessHandler(successHandler)
					.useSecureCookie(true)
					;
			})
			.sessionManagement(session->{
				session
					.maximumSessions(100)
					.maxSessionsPreventsLogin(true)
					.expiredUrl("/member/join")
					;
			})
			.logout(logout->{
				logout
					.logoutUrl("/member/logout")
					.logoutSuccessUrl("/member/login")
					.invalidateHttpSession(true)
					.deleteCookies("JESSIONID")
					;
			})
			;
		return security.build();
	}
}
