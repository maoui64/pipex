/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   gnl.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/08/25 12:13:27 by magahat           #+#    #+#             */
/*   Updated: 2024/08/26 11:14:17 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

static char	*ft_find_new_line(char *stash)
{
	int	i;

	i = 0;
	while (stash[i] && stash[i] != '\n')
		i++;
	if (stash[i] == 0 || stash[i + 1] == 0)
		return (NULL);
	if (stash[i] == '\n')
		return (&stash[i + 1]);
	return (NULL);
}

static char	*ft_extract_line(char *stash)
{
	int		i;
	char	*line;

	i = 0;
	while (stash[i] != '\n' && stash[i])
		i++;
	if (stash[i] == '\n')
		i++;
	line = malloc(sizeof(char) * (i + 1));
	if (!line)
		return (NULL);
	i = 0;
	while (stash[i] != '\n' && stash[i])
	{
		line[i] = stash[i];
		i++;
	}
	if (stash[i] == '\n')
	{
		line[i] = '\n';
		i++;
	}
	line[i] = '\0';
	return (line);
}

static char	*ft_new_line(char *stash)
{
	char	*tmp;

	if (!(ft_strchr(stash, '\n')))
	{
		free(stash);
		return (NULL);
	}
	tmp = ft_strdup(stash);
	free(stash);
	stash = ft_strdup(ft_find_new_line(tmp));
	free(tmp);
	return (stash);
}

static char	*ft_read_line(int fd, char *stash, char *buf)
{
	int		size_read;
	char	*tmp;

	size_read = 1;
	while (size_read != 0 && !(ft_strchr(stash, '\n')))
	{
		size_read = read(fd, buf, BUFFER_SIZE);
		if (size_read == 0)
			break ;
		if (size_read == -1)
			return (ft_free_double(stash, buf));
		buf[size_read] = '\0';
		tmp = ft_strdup(stash);
		free(stash);
		stash = ft_strjoin(tmp, buf);
		free(tmp);
	}
	free(buf);
	return (stash);
}

int	get_next_line(char **line, int fd)
{
	static char	*stash;
	char		*buf;

	if (fd < 0 || BUFFER_SIZE <= 0 || BUFFER_SIZE > INT_MAX || !line)
		return (-1);
	buf = malloc(sizeof(char) * (BUFFER_SIZE + 1));
	if (!buf)
		return (-1);
	stash = ft_read_line(fd, stash, buf);
	if (ft_strlen(stash) == 0)
		return (-1);
	*line = ft_extract_line(stash);
	stash = ft_new_line(stash);
	return (1);
}
