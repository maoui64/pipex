/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/26 14:52:00 by magahat           #+#    #+#             */
/*   Updated: 2024/08/26 18:30:18 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

/* to include : open, waitpid*/
# include <fcntl.h>
# include <sys/types.h>
# include <sys/stat.h>
# include <sys/wait.h>
/* to include : close, read, write, access, dup2, 
execve, fork, pipe*/
# include <unistd.h>
/* to include : malloc, free, exit*/
# include <stdlib.h>
/* to include : perror, std_fileno*/
# include <stdio.h>
# include <limits.h>
# include "../libft/libft.h"

# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 1
# endif

typedef struct s_pipex
{
	int	file[2];
	int	*pipes;
	int	nb_cmd;
	int	here_doc;
	int	err;
}	t_pipex;

int		exit_handler(int n);
void	free_double(char **tab);
int		*open_fd(char *infile, char *outfile, int *file, int i);
void	manage_cmd(char **argv, char **envp, t_pipex pipex);
int		*open_pipes(int nb_cmd);
void	close_fd(t_pipex pipex);

/*function bonus*/
char	*ft_free_double(char *s1, char *s2);
int		get_next_line(char **line, int fd);

#endif