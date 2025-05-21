import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { RouterLink, Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';
import { GlobalUserService } from '../../../services/global-user.service';
import { UserService } from '../../../services/user.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, RouterLink, ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  loginForm: FormGroup;
  successMessage: string = ''; // Message de succès
  errorMessage: string = '';

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private userService: UserService,
    private globalUserService: GlobalUserService,
    private router: Router
  ) {
    this.loginForm = this.formBuilder.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(12)]]
    });
  }

  onSubmit() {
    console.log('Formulaire soumis');
    if (this.loginForm.valid) {
      const { email, password } = this.loginForm.value;

      this.authService.login(email, password).subscribe({
        next: (response) => {
          console.log('Connexion réussie', response);
          localStorage.setItem('token', response.accessToken);

          // Récupérer l'utilisateur via le token
          const token = localStorage.getItem('token') as string;
          this.userService.getUserByToken(token).subscribe({
            next: (user) => {
              this.globalUserService.saveUser(user); // Stocker l'utilisateur dans le service global
              this.errorMessage = '';
              this.successMessage = 'Connexion réussie ! Vous serez redirigé dans 3 secondes.';
              console.log('Utilisateur connecté et sauvegardé:', this.globalUserService.currentUser);

              // Rediriger après 3 secondes
              setTimeout(() => {
                this.router.navigate(['/accueil']);
              }, 3000);
            },
            error: (error) => {
              console.error("Erreur lors de la récupération de l'utilisateur:", error);
            }
          });
        },
        error: (error) => {
          console.error('Erreur de Connexion', error);
          this.errorMessage = error?.error?.message || "Erreur de connexion. Veuillez vérifier vos identifiants.";
        }
      });
    } else {
      this.errorMessage = 'Veuillez corriger les erreurs du formulaire.';
    }
  }
}